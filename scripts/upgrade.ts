import { Contract, ContractFactory } from "ethers";
import { ethers, run, upgrades } from "hardhat";

async function main(): Promise<void> {
  const Factory: ContractFactory = await ethers.getContractFactory("BaseCollectionUpgradeable");
  const contract: Contract = await upgrades.upgradeProxy("0x191EC8e3F3cb12a87F33aA9582886C424446A775", Factory, {
    kind: "uups",
  });

  await contract.deployed();
  console.log("Factory upgraded to : ", await upgrades.erc1967.getImplementationAddress(contract.address));

  // const RoleManager: ContractFactory = await ethers.getContractFactory("RoleManagerUpgradeable");
  // const contract: Contract = await upgrades.upgradeProxy("0x75649D5FB65029492A7eE7Fd7cB9DF80Ca9459A2", RoleManager, {
  //   kind: "uups",
  // });
  // await contract.deployed();
  // console.log("Factory upgraded to : ", await upgrades.er90c1967.getImplementationAddress(contract.address));

  await run(`verify:verify`, {
    address: contract.address,
  });
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
