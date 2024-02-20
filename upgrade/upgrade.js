// deploy.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const MyContract = await ethers.getContractFactory("MyContract");
  const myContract = await upgrades.deployProxy(MyContract, [100]);
  await myContract.deployed();
  console.log("MyContract deployed to:", myContract.address);

  const UpgradedMyContract = await ethers.getContractFactory("UpgradedMyContract");
  const upgradedContract = await upgrades.upgradeProxy(myContract.address, UpgradedMyContract);
  console.log("UpgradedMyContract deployed to:", upgradedContract.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
