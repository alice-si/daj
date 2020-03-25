pragma solidity ^0.5.0;

/************
@title IAssetBacked interface
@notice Helper interface answering what type of underlying asset is being used by the contract.
*/

interface IAssetBacked {

  function isEthBacked() external returns(bool);

}
