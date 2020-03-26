var AaveExternalPool = artifacts.require("./AaveExternalPool.sol");
var FutureToken = artifacts.require("./FutureToken.sol");

const ETH_ADDRESS = "0x000000000000000000000000000000000000000E";


module.exports = function(deployer) {
  deployer.deploy(FutureToken,
    "0xBC773Ca86D9071e163168a8A5aD25e235907F9e7", //Interest rates oracle
    AaveExternalPool.address,
    ETH_ADDRESS); //ETH symbol
};
