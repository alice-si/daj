pragma solidity ^0.5.0;

import "./IExternalPool.sol";

/************
@title MockExternalPool
@notice Mock implementation of external lending pool for test purpose
*/

contract MockExternalPool is IExternalPool {

  uint256 balance;

  function deposit(uint256 amount) external payable {
    balance += amount;
  }

  function withdraw(uint256 amount, address payable beneficiary) external {
    balance -= amount;
    beneficiary.transfer(amount);
  }

  function balanceOf(address account) external view returns(uint256) {
    return balance;
  }
}
