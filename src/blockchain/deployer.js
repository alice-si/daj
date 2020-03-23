import { getFUTURE_TOKEN, getAAVE_EXTERNAL_POOL } from "./contracts.js";
import { saveDetailsIn3Box } from "./3box-connector.js";

import deployment from './deployment.json';
import {getMainAccount} from "./network";



export async function deployAaveEthPool() {
  console.log("Deploying Aave external pool...");
  let AAVE_EXTERNAL_POOL = await getAAVE_EXTERNAL_POOL();
  let aep = await AAVE_EXTERNAL_POOL.new(deployment.AAVE_ETH_RESERVE, deployment.LENDING_POOL);

  console.log("Aave external ETH pool deployed: " + aep.address);
  return aep;
}


export async function deployFutureEthToken() {
  console.log("Deploying future ETH token...");
  let aepAddress = "0x00Ca1D94B89E1281218c4F50c74b424A559Cb67b";
  let FUTURE_TOKEN = await getFUTURE_TOKEN();
  let main = await getMainAccount();
  let ft = await FUTURE_TOKEN.new(main, "0x00Ca1D94B89E1281218c4F50c74b424A559Cb67b");

  console.log("FT deployed to: " + ft.address);
}
