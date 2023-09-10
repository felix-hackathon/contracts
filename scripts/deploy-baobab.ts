import { DeployProxyOptions } from "@openzeppelin/hardhat-upgrades/dist/utils";
import * as dotenv from "dotenv";
import { Contract, ContractFactory } from "ethers";
import { ethers, run, upgrades } from "hardhat";

dotenv.config();

const deployAndVerify = async (
  name: string,
  params: unknown[],
  canVerify: boolean = true,
  path?: string | undefined,
  proxyOptions?: DeployProxyOptions | undefined,
): Promise<Contract> => {
  const Factory: ContractFactory = await ethers.getContractFactory(name);
  const instance: Contract = proxyOptions
    ? await upgrades.deployProxy(Factory, params, proxyOptions)
    : await Factory.deploy(...params);
  await instance.deployed();

  if (canVerify)
    await run(`verify:verify`, {
      contract: path,
      address: instance.address,
      constructorArguments: proxyOptions ? [] : params,
    });

  console.log(`${name} deployed at: ${instance.address}`);

  return instance;
};

async function main() {
  // const admin = "0xc95C0EC40937aD81F34c8b0836680b7681b7bF60";
  // const operators = ["0xc95C0EC40937aD81F34c8b0836680b7681b7bF60"];
  // const minters = ["0xc95C0EC40937aD81F34c8b0836680b7681b7bF60"];
  // const name = "RoleManager";
  // const version = "1";

  // const roleManager = await deployAndVerify(
  //   "RoleManagerUpgradeable",
  //   [admin, operators, minters, name, version],
  //   false,
  //   "contracts/RoleManagerUpgradeable.sol:RoleManagerUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("RoleManagerUpgradeable: ", roleManager.address);

  const roleManager = "0xBB8E2544d6B763191eaE61DFB6314d7A3d2846Bc";
  // const registry = "0x02101dfB77FDE026414827Fdc604ddAF224F0921";
  // const implementation = "0x2298edBc3ccF222B579FECd4E2fd701B88f1E56D";
  // const uri = "https://api.swiftsell.store/nft/metadata/1001";
  // const price = ethers.utils.parseUnits("0.1", "ether");
  // const types = [[ethers.constants.AddressZero, price]];

  // const colorContract = await deployAndVerify(
  //   "AccessoryCollectionUpgradeable",
  //   [roleManager, "Color", "Color", uri, types],
  //   false,
  //   "contracts/AccessoryCollectionUpgradeable.sol:AccessoryCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Color: ", colorContract.address);

  // //
  // const CalipersContract = await deployAndVerify(
  //   "AccessoryCollectionUpgradeable",
  //   [roleManager, "Calipers", "Calipers", uri, types],
  //   false,
  //   "contracts/AccessoryCollectionUpgradeable.sol:AccessoryCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Calipers: ", CalipersContract.address);

  // const RimContract = await deployAndVerify(
  //   "AccessoryCollectionUpgradeable",
  //   [roleManager, "Rim", "Rim", uri, types],
  //   false,
  //   "contracts/AccessoryCollectionUpgradeable.sol:AccessoryCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Rim: ", RimContract.address);

  // //
  // const BrakeDiskContract = await deployAndVerify(
  //   "AccessoryCollectionUpgradeable",
  //   [roleManager, "Brake Disk", "Brake Disk", uri, types],
  //   false,
  //   "contracts/AccessoryCollectionUpgradeable.sol:AccessoryCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Brake Disk: ", BrakeDiskContract.address);

  // //
  // const WindShieldContract = await deployAndVerify(
  //   "AccessoryCollectionUpgradeable",
  //   [roleManager, "Wind Shield", "Wind Shield", uri, types],
  //   false,
  //   "contracts/AccessoryCollectionUpgradeable.sol:AccessoryCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Wind Shield: ", WindShieldContract.address);

  // //
  // const BaseCollectionUpgradeable = await deployAndVerify(
  //   "BaseCollectionUpgradeable",
  //   [roleManager, "Car", "Car", registry, implementation, uri, types],
  //   false,
  //   "contracts/BaseCollectionUpgradeable.sol:BaseCollectionUpgradeable",
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   },
  // );
  // console.log("Car: ", BaseCollectionUpgradeable.address);

  const PaymentGatewayUpgradeable = await deployAndVerify(
    "PaymentGatewayUpgradeable",
    [roleManager],
    false,
    "contracts/PaymentGatewayUpgradeable.sol:PaymentGatewayUpgradeable",
    {
      kind: "uups",
      initializer: "initialize",
    },
  );
  console.log("PaymentGateway: ", PaymentGatewayUpgradeable.address);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
