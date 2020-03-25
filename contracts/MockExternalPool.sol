pragma solidity ^0.5.0;

import "./IExternalPool.sol";
import "./IAssetBacked.sol";

/************
@title MockExternalPool
@notice Mock implementation of external lending pool for test purpose
*/

contract MockExternalPool is IExternalPool {

  address public token;
  uint256 balance;

  function isEthBacked() internal returns(bool) {
    IAssetBacked callee = IAssetBacked(msg.sender);
    return callee.isEthBacked();
  }

  function deposit(uint256 amount) external payable {
    balance += amount;
  }

  function withdraw(uint256 amount, address payable beneficiary) external {
    balance -= amount;
    if (isEthBacked()) {
      beneficiary.transfer(amount);
    }
  }

  function balanceOf(address account) external view returns(uint256) {
    return balance;
  }


}
