const { expect } = require("chai");

describe("Vulnerable", function () {
  it("should allow reentrancy exploit", async function () {
    const hre = require("hardhat");
    const { ethers } = hre;

    const [owner, attacker] = await ethers.getSigners();

    const Vuln = await ethers.getContractFactory("Vulnerable", owner);
    const vuln = await Vuln.deploy();
    await vuln.waitForDeployment();

    const oneEth = ethers.parseEther("100")
    const pointOneEth = ethers.parseEther("100")
    await vuln.donate({ value: oneEth });

    const Exploit = await ethers.getContractFactory("Exploit", attacker);
    const exploit = await Exploit.deploy(await vuln.getAddress());
    await exploit.waitForDeployment();

    await exploit.attack({ value: pointOneEth });

    const balance = await ethers.provider.getBalance(await vuln.getAddress());
    expect(balance).to.equal(0n);
  });
});
