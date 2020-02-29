import {EventBus} from "../event-bus";
import { getWeb3, getMainAccount } from "./network.js";

var box;

async function getBox() {
  let web3 = await getWeb3();
  let main = await getMainAccount();
  if (box === undefined && web3) {
    if (!Box.isLoggedIn(main)) {
      EventBus.$emit('3box-login');
    }
    box = await Box.openBox(main, web3.currentProvider);
  }
  return box;
}

export async function saveDetailsIn3Box(newIda) {
  await getBox();
  const space = await box.openSpace(newIda.name);
  await space.public.set('project-description', newIda.projectDescription);
  await space.public.set('organisation-name', newIda.organisationName);
  await space.public.set('organisation-description', newIda.organisationDescription);
  await space.public.set('promise-description', newIda.promiseDescription);
  await space.public.set('validator-name', newIda.validatorName);
}

export async function getIdaData(ida) {
  return await Box.getSpace(ida.creator, ida.name);
}
