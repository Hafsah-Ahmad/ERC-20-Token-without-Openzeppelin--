const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Shitzu Token (shit)", function () {
  let MyToken, myToken, owner, user1, user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    MyToken = await ethers.getContractFactory("MyToken");
    myToken = await MyToken.deploy();
    await myToken.waitForDeployment();
  });

  it("should assign total supply to owner", async function () {
    const ownerBalance = await myToken.balanceOf(owner.address);
    expect(ownerBalance).to.equal(await myToken.totalSupply());
  });

  it("should transfer tokens between accounts", async function () {
    await myToken.transfer(user1.address, ethers.parseUnits("100", 18));
    const userBalance = await myToken.balanceOf(user1.address);
    expect(userBalance).to.equal(ethers.parseUnits("100", 18));
  });

  it("should not allow transfers when paused", async function () {
    await myToken.pause();
    await expect(
      myToken.transfer(user1.address, ethers.parseUnits("10", 18))
    ).to.be.revertedWith("paused");
  });

  it("should freeze and unfreeze accounts", async function () {
    await myToken.freeze(user1.address);
    await expect(
      myToken.connect(user1).transfer(user2.address, ethers.parseUnits("10", 18))
    ).to.be.revertedWith("account is frozen");

    await myToken.unfreeze(user1.address);
    await myToken.transfer(user1.address, ethers.parseUnits("10", 18));
    await myToken.connect(user1).transfer(user2.address, ethers.parseUnits("10", 18));

    expect(await myToken.balanceOf(user2.address)).to.equal(ethers.parseUnits("10", 18));
  });

  it("should burn tokens from an account", async function () {
    const initialSupply = await myToken.totalSupply();
    await myToken.approve(owner.address, ethers.parseUnits("50", 18));
    await myToken.burnFrom(owner.address, ethers.parseUnits("50", 18));
    const newSupply = await myToken.totalSupply();
    expect(newSupply).to.equal(initialSupply - ethers.parseUnits("50", 18));
  });
});
