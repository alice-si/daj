const {promisify} = require("es6-promisify");
let ethereum = window.ethereum;
const detectNetwork = require('web3-detect-network');

var web3, main;

export async function getWeb3() {
  if (web3) {
    return web3;
  }

  if (typeof ethereum !== 'undefined') {
    await ethereum.enable();
    web3 = new Web3(ethereum);
  } else if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
  } else {
    throw 'NO_WEB3'
  }
  let network = await detectNetwork(web3.currentProvider);

  console.log("Connected to network: " + network.id);

  return web3;
};

export async function getMainAccount() {
  if (main) {
    return main;
  }
  await getWeb3();
  let getAccounts = promisify(web3.eth.getAccounts);
  let accounts = await getAccounts();
  if (accounts.length > 0) {
    main = accounts[0];
    console.log("Connected web3 account: " + main);
  } else {
    console.log("No web3 accounts available.")
  }
  return main;
}




