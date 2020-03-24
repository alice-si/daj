pragma solidity ^0.5.0;

import "./IExternalPool.sol";

/************
@title IExternalPool interface
@notice Interface for connection to external lending pools;
*/

import "./aave/tokenization/AToken.sol";
import "./aave/lendingpool/LendingPool.sol";
import "./aave/libraries/EthAddressLib.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract AaveExternalPool is IExternalPool {

  address public reserve;
  LendingPool public lendingPool;

  constructor(address _reserve, LendingPool _lendingPool) public {
    reserve = _reserve;
    lendingPool = _lendingPool;
  }

  function deposit(uint256 amount) external payable {
    if (reserve == EthAddressLib.ethAddress()) {
      lendingPool.deposit.value(amount)(reserve, amount, 0);
    } else {
      lendingPool.deposit(reserve, amount, 0);
    }
  }

  function withdraw(uint256 amount, address payable beneficiary) external {
    address aTokenAddress;
    ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
    AToken aToken = AToken(aTokenAddress);
    aToken.redeem(amount);
    if (reserve == EthAddressLib.ethAddress()) {
      beneficiary.transfer(amount);
    } else {
      ERC20 depositedToken = ERC20(aToken.underlyingAssetAddress());
      depositedToken.transfer(beneficiary, amount);
    }
  }

  function balanceOf(address account) external view returns(uint256) {
    address aTokenAddress;
    ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
    AToken aToken = AToken(aTokenAddress);
    return aToken.balanceOf(account);
  }
}
