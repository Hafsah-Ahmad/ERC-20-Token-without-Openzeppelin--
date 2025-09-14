const hre = require("hardhat");

async function main() {
  const [deployer, user] = await hre.ethers.getSigners();

  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy();
  await myToken.waitForDeployment();

  console.log("✅ Token deployed at:", await myToken.getAddress());

  // Check deployer balance
  let balance = await myToken.balanceOf(deployer.address);
  console.log("Deployer balance:", hre.ethers.formatUnits(balance, 18), "SHIT");

  // Transfer 100 SHIT to user
  const tx = await myToken.transfer(user.address, hre.ethers.parseUnits("100", 18));
  await tx.wait();

  balance = await myToken.balanceOf(user.address);
  console.log("User balance after transfer:", hre.ethers.formatUnits(balance, 18), "SHIT");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
