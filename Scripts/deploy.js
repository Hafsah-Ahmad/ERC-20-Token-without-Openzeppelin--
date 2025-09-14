const hre = require("hardhat");

async function main() {
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy();

  await myToken.waitForDeployment();

  console.log("✅ Shitzu Token deployed to:", await myToken.getAddress());
  console.log("Name:", await myToken.name());
  console.log("Symbol:", await myToken.symbol());
  console.log("Total Supply:", (await myToken.totalSupply()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
