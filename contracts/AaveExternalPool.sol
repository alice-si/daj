pragma solidity ^0.5.0;

import "./IExternalPool.sol";

/************
@title IExternalPool interface
@notice Interface for connection to external lending pools;
*/

import "./aave/tokenization/AToken.sol";
import "./aave/lendingpool/LendingPool.sol";

contract AaveExternalPool is IExternalPool {

  address public reserve;
  LendingPool public lendingPool;

  constructor(address _reserve, LendingPool _lendingPool) public {
    reserve = _reserve;
    lendingPool = _lendingPool;
  }

  function deposit(uint256 amount) external payable {
    lendingPool.deposit.value(amount)(reserve, amount, 0);
  }

  function withdraw(uint256 amount) external {
    address aTokenAddress;
    ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
    AToken aToken = AToken(aTokenAddress);
    aToken.redeem(amount);
  }

  function balanceOf(address account) external view returns(uint256) {
    address aTokenAddress;
    ( , , , , , , , , , , ,aTokenAddress, ) = lendingPool.getReserveData(reserve);
    AToken aToken = AToken(aTokenAddress);
    return aToken.balanceOf(account);
  }
}
