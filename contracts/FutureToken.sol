pragma solidity ^0.5.0;

import "./aave/tokenization/AToken.sol";
import "./aave/lendingpool/LendingPool.sol";
import "./aave/libraries/WadRayMath.sol";
import "./Calendar.sol";
import "erc-1155/contracts/IERC1155.sol";

/**
 * @title Future Token
 *
 */
contract FutureToken is IERC1155 {
  using WadRayMath for uint256;
  using SafeMath for uint256;


  /**
  * @dev emitted after the redeem action
  * @param _from the address performing the redeem
  * @param _value the amount to be redeemed
  * @param _value interests received
  **/
  event Deposit(address indexed _from, uint256 _value, uint256 _interests);

  modifier onlyInterestRatesOracle() {
    require(msg.sender == interestRatesOracle, "The caller is not the interest rates oracle");
    _;
  }

  uint256 internal constant MAX_RATE = 10000;
  uint256 internal constant INTERESTS_SLOT = 7777777;

  mapping (uint256 => mapping(address => uint256)) internal balances;

  LendingPool public lendingPool;
  address public reserve;

  //An oracle authorized to set interest rates
  address public interestRatesOracle;

  uint256 public interestRate;

  constructor(address _interestRatesOracle, uint256 _interestRate, address _reserve, LendingPool _lendingPool) public {
    reserve = _reserve;
    lendingPool = _lendingPool;
    interestRate = _interestRate;
    interestRatesOracle = _interestRatesOracle;
  }

  function setInterestRates(uint _newRate) external onlyInterestRatesOracle {
    interestRate = _newRate;
  }

  /**
   * @notice ERC20 implementation internal function backing transfer() and transferFrom()
   * @dev validates the transfer before allowing it. NOTE: This is not standard ERC20 behavior
   **/
  function deposit(uint256 _amount, uint256 periodDiff) external payable {
    uint256 interests = getWarpPrice(_amount, periodDiff, true);
    uint256 currentPeriod = this.getCurrentPeriod();

    //Deposit to lending pool
    uint256 lendingPoolDeposit = _amount.sub(interests);
    lendingPool.deposit.value(lendingPoolDeposit)(reserve, lendingPoolDeposit, 0);

    //Update internal ledger
    _mint(msg.sender, currentPeriod.add(periodDiff), _amount);
    _mint(msg.sender, INTERESTS_SLOT, interests);

    //Return instant interests
    msg.sender.transfer(interests);

    emit Deposit(msg.sender, _amount, interests);
  }

  function withdraw(uint256 _amount) external {
    uint256 period = this.getCurrentPeriod();
    require(this.balanceOf(msg.sender, period) >= _amount, "No enough funds available");

    //Return funds from Aave
    address aTokenAddress;
    ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
    AToken aToken = AToken(aTokenAddress);
    uint256 toRedeem = _amount > aToken.balanceOf(address(this)) ?  aToken.balanceOf(address(this)) : _amount;
    aToken.redeem(toRedeem);
    msg.sender.transfer(toRedeem);

    _burn(msg.sender, period, toRedeem);
  }

  function warp(uint256 _amount, uint256 _periodFrom, uint256 _periodTo) external payable {
    require(this.balanceOf(msg.sender, _periodFrom) >= _amount, "No enough funds available");
    require(_periodTo >= this.getCurrentPeriod(), "Cannot transfer to the past");

    bool isForward = _periodTo > _periodFrom;
    uint256 periodDiff = isForward ? _periodTo.sub(_periodFrom): _periodFrom.sub(_periodTo);
    uint256 warpPrice = getWarpPrice(_amount, periodDiff, isForward);

    if (isForward) {
      balances[INTERESTS_SLOT][msg.sender] = balances[INTERESTS_SLOT][msg.sender].add(warpPrice);
      //Redeem outstanding deposit from Aave pool
      address aTokenAddress;
      ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
      AToken aToken = AToken(aTokenAddress);
      aToken.redeem(warpPrice);
      msg.sender.transfer(warpPrice);
    } else {
      uint256 effectivePrice = warpPrice > balances[INTERESTS_SLOT][msg.sender] ? balances[INTERESTS_SLOT][msg.sender] : warpPrice;
      balances[INTERESTS_SLOT][msg.sender] = balances[INTERESTS_SLOT][msg.sender].sub(effectivePrice);
      //Add missing deposit to Aave pool
      lendingPool.deposit.value(warpPrice)(reserve, warpPrice, 0);
    }

    balances[_periodFrom][msg.sender] = balances[_periodFrom][msg.sender].sub(_amount);
    balances[_periodTo][msg.sender] = balances[_periodTo][msg.sender].add(_amount);

    emit TransferSingle(msg.sender, msg.sender, msg.sender, _periodTo, _amount);
  }

  function getCurrentPeriod() external view returns(uint256) {
    return Calendar.getCurrentMonth();
  }


  function getWarpPrice(uint256 _amount, uint256 _periodDiff, bool isForward) public view returns(uint256) {
    uint256 formula = MAX_RATE.add(interestRate.mul(_periodDiff).div(12));
    if (isForward) {
        return _amount.sub(_amount.mul(MAX_RATE).div(formula));
    } else {
        return _amount.mul(formula).div(MAX_RATE).sub(_amount);
    }
  }

  /**
     * @dev Internal function to mint an amount of a token with the given ID
     * @param to The address that will own the minted token
     * @param id ID of the token to be minted
     * @param value Amount of the token to be minted
     */
  function _mint(address to, uint256 id, uint256 value) internal {
    require(to != address(0), "ERC1155: mint to the zero address");

    balances[id][to] = value.add(balances[id][to]);
    emit TransferSingle(msg.sender, address(0), to, id, value);
  }


  /**
     * @dev Internal function to burn an amount of a token with the given ID
     * @param owner Account which owns the token to be burnt
     * @param id ID of the token to be burnt
     * @param value Amount of the token to be burnt
     */
  function _burn(address owner, uint256 id, uint256 value) internal {
    balances[id][owner] = balances[id][owner].sub(value);
    emit TransferSingle(msg.sender, owner, address(0), id, value);
  }

  function spaceTransfer(address _to, uint256 _id, uint256 _value) external {
    balances[_id][msg.sender] = balances[_id][msg.sender].sub(_value);
    balances[_id][_to] = balances[_id][_to].add(_value);
    emit TransferSingle(msg.sender, msg.sender, _to, _id, _value);
  }

  /**
      @notice Get the balance of an account's Tokens.
      @param _owner  The address of the token holder
      @param _id     ID of the Token
      @return        The _owner's balance of the Token type requested
   */
  function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
    // The balance of any account can be calculated from the Transfer events history.
    // However, since we need to keep the balances to validate transfer request,
    // there is no extra cost to also privide a querry function.
    return balances[_id][_owner];
  }

  function balancesOfYear(address _owner) external view returns (uint256[] memory) {
    uint256[] memory balances = new uint256[](12);
    for(uint i = 0; i < 12; i++) {
      balances[i] = this.balanceOf(_owner, i);
    }
    return balances;
  }

  function getTotalInterests() external view returns (uint256) {
    return balances[INTERESTS_SLOT][msg.sender];
  }

  /**
      Default payable function to accept money from Lending Pools
   */
  function() external payable { }

  //IERC-1155 Functions to be implemented later
  function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {}

  function setApprovalForAll(address _operator, bool _approved) external {}

  function isApprovedForAll(address _owner, address _operator) external view returns (bool) {}

  function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external { }

  function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external { }




}
