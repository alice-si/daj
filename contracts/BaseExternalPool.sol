pragma solidity ^0.5.0;

import "./IExternalPool.sol";
import "./IAssetBacked.sol";

/***
  @title BaseExternalPool
  @notice A base class implementing the common logic for external liquidity pools connectors
*/

contract BaseExternalPool is IExternalPool {

  address constant ETHER = address(0xE);
  uint256 constant UINT256_MAX = ~uint256(0);

  function isEthBacked() internal view returns(bool) {
    IAssetBacked callee = IAssetBacked(msg.sender);
    return callee.isEthBacked();
  }

  function backingAsset() internal view returns(IERC20) {
    IAssetBacked callee = IAssetBacked(msg.sender);
    return callee.backingAsset();
  }

}
