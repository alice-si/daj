import { getMainAccount } from "./network.js";
import state from "@/state";

export async function getWalletBalance() {
  let main = await getMainAccount();
  //state.balance.tokens = parseInt(web3.fromWei(await ausd.balanceOf(main), 'ether'));
}
