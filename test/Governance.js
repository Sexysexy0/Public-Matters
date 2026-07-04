import { expect } from "chai";
import hre from "hardhat";

describe("SecurityGovernance Authorization Flow", function () {
  async function deployGovernanceFixture() {
    const [owner, otherAccount] = await hre.ethers.getSigners();
    const SecurityGovernance = await hre.ethers.getContractFactory("SecurityGovernance");
    const governance = await SecurityGovernance.deploy(owner.address);

    return { governance, owner, otherAccount };
  }

  it("Should restrict emergency pause to the default admin role only", async function () {
    const { governance, otherAccount } = await deployGovernanceFixture();

    await expect(
      governance.connect(otherAccount).triggerEmergencyPause()
    ).to.be.revertedWithCustomError(governance, "AccessControlUnauthorizedAccount");
  });
});
