import {getFutureToken, getExternalPool } from "./contracts.js";
import {getMainAccount} from "./network";

const SCALING_FACTOR = 1;
const CURRENCIES = ['ETH'];
const ETH_QUERY_URL = 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD&api_key=88ef2a2548eace3ed76a7b5f2999c24fd90a204df704d3773fc0c76caa587c52';

async function getTreasure(currency) {
  let pool = await getExternalPool(currency);
  let b = await pool.balanceOf(pool.address);
  let treasure = web3.fromWei(b, 'ether');
  return treasure;
}

export async function getTreasures() {
  console.log("Getting treasure...");
  let main = await getMainAccount();
  var treasure = {};
  treasure['ETH'] = await getTreasure('ETH');
  return treasure;
}

export async function ethToUsd(val) {
  let price = await  getEtherPrice();
  return val * price;
}

export async function getEtherPrice() {
  let response = await fetch(ETH_QUERY_URL);
  let data = await response.json();
  return data.USD;

}
