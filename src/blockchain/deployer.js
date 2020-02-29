import { getFUTURE_TOKEN, getSTS_FACTORY, getIP_FACTORY, getESCROW_FACTORY, getCLAIMS_REGISTRY, getIDA_FACTORY, getIdaFactory } from "./contracts.js";
import { saveDetailsIn3Box } from "./3box-connector.js";

import deployment from './deployment.json';
import {getMainAccount} from "./network";


export async function deployFutureToken() {
  let FUTURE_TOKEN = await getFUTURE_TOKEN();
  let main = await getMainAccount();
  let ft = await FUTURE_TOKEN.new(main, 500, deployment.RESERVE, deployment.LENDING_POOL);

  console.log("FT deployed to: " + ft.address);
}
