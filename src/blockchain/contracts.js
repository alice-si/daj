import contract from "truffle-contract";
import { getWeb3, getMainAccount } from "./network.js";

import LENDING_POOL_JSON from '@contracts/LendingPool.json'
import AAVE_EXTERNAL_POOL_JSON from '@contracts/AaveExternalPool.json'
import FUTURE_TOKEN_JSON from '@contracts/FutureToken.json'
import IR_STRATEGY_JSON from '@contracts/DefaultReserveInterestRateStrategy.json'
import ERC20_JSON from '@contracts/ERC20.json'

import deployment from './deployment.json';

var setup = async function(json) {
  let web3 = await getWeb3();
  let main = await getMainAccount();
  let c = contract(json);
  c.setProvider(web3.currentProvider);
  c.defaults({
    from: main,
    gas: 7000000
  });
  return c;
};

var ft, ir, dai, pool;

export async function getFUTURE_TOKEN() {
  return await setup(FUTURE_TOKEN_JSON);
}

export async function getAAVE_EXTERNAL_POOL() {
  return await setup(AAVE_EXTERNAL_POOL_JSON);
}


export async function getLendingPool() {
  if (pool === undefined) {
    let LENDING_POOL = await setup(LENDING_POOL_JSON);
    pool = await LENDING_POOL.at(deployment.LENDING_POOL);
    console.log("Linked lending pool: " + pool.address);
  }
  return pool;
}

export async function getInterestRatesStrategy() {
  if (ir === undefined) {
    let IR = await setup(IR_STRATEGY_JSON);
    ir = await FC.at(deployment.INTEREST_RATES_STRATEGY);
    console.log("Linked interest rates strategy: " + ir.address);
  }
  return ir;
}


export async function getFutureToken(currency) {
  console.log("Getting future token contract for: " + currency);
  if (ft === undefined) {
    let FT = await setup(FUTURE_TOKEN_JSON);
    ft = await FT.at(deployment['FUTURE_TOKEN_' + currency]);
    console.log("Linked future token " + currency + ": " + ft.address);
  }
  return ft;
}


export async function getExternalPool() {
  let EXTERNAL_POOL = await getAAVE_EXTERNAL_POOL();
  let pool = await EXTERNAL_POOL.at(deployment.A_EXTERNAL_POOL);
  return pool;
}


export async function getDaiToken() {
  if (dai === undefined) {
    let DAI = await setup(ERC20_JSON);
    dai = await DAI.at(deployment.DAI);
    console.log("Linked dai token: " + dai.address);
  }
  return dai;
}




