import { getFUTURE_TOKEN, getAAVE_EXTERNAL_POOL } from "./contracts.js";
import { saveDetailsIn3Box } from "./3box-connector.js";

import deployment from './deployment.json';
import {getMainAccount} from "./network";

const ETH_ADDRESS = "0x000000000000000000000000000000000000000E";

export async function deployAaveExternalPool() {
  console.log("Deploying Aave external ETH pool...");
  let AAVE_EXTERNAL_POOL = await getAAVE_EXTERNAL_POOL();
  let aep = await AAVE_EXTERNAL_POOL.new(deployment.LENDING_POOL);

  console.log("Aave external ETH pool deployed: " + aep.address);
  return aep;
}


export async function deployFutureEthToken() {
  console.log("Deploying future ETH token...");
  let FUTURE_TOKEN = await getFUTURE_TOKEN();
  let main = await getMainAccount();
  let ft = await FUTURE_TOKEN.new(main, deployment.A_EXTERNAL_POOL, ETH_ADDRESS);

  console.log("FT deployed to: " + ft.address);
}
