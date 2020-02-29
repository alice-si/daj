import { getFutureToken } from "./contracts.js";
import {getMainAccount} from "./network";

const SCALING_FACTOR = 1;

export async function getLendingData() {
  console.log("Getting lending deta");
  let fc = await getFutureCoin();
  let main = await getMainAccount();
  let data = await fc.getLendingPoolData(main);

  console.log(data);
}

export async function makeDeposit(_amount, _time) {
  console.log("Depositing: " + _amount + " for: " + _time + " months");
  let fc = await getFutureToken();
  let wei = web3.toWei(_amount/SCALING_FACTOR, 'ether');
  let tx = await fc.deposit(wei, _time, {value: wei});

  console.log(tx);
}

export async function spaceTransfer(_to, _id, _amount) {
  console.log("Transfering in space: " + _amount + " to: " + _to + " from period: " + _id);
  let fc = await getFutureToken();
  let wei = web3.toWei(_amount/SCALING_FACTOR, 'ether');
  let tx = await fc.spaceTransfer(_to, _id, wei);

  console.log(tx);
}

export async function getBalances() {
  console.log("Getting balances...");
  let fc = await getFutureToken();
  let main = await getMainAccount();
  let rawBalances = await fc.balancesOfYear(main);


  let total = 0;
  let balances = rawBalances.map( b => {
    let f = web3.fromWei(b, 'ether') * SCALING_FACTOR;
    total += f;
    return f;
  });


  balances[12] = total;
  if (total > 0) {
    let rawInterests = await fc.getTotalInterests();
    balances[77] = web3.fromWei(rawInterests, 'ether') * SCALING_FACTOR;
  }
  console.log(balances);
  return balances;
}
