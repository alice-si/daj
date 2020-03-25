pragma solidity ^0.5.0;

library AaveKovanDeployment {

  /**
  * @dev returns the address used within the protocol to identify ETH
  * @return the address assigned to ETH
   */
  function ethAddress() internal pure returns(address) {
    return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  }


  /**
  * @dev returns the address used within the protocol to identify DAI
  * @return the address assigned to DAI
   */
  function daiAddress() internal pure returns(address) {
    return 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD;
  }
}
