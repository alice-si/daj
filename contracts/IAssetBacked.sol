pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/************
@title IAssetBacked interface
@notice Helper interface answering what type of underlying asset is being used by the contract.
*/

interface IAssetBacked {

  function isEthBacked() external view returns(bool);

  function backingAsset() external view returns(IERC20);

}
