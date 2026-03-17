const { expect } = require("chai");

describe("HempAccessDAO", function () {
  it("Should create and vote on proposal", async function () {
    const DAO = await ethers.getContractFactory("HempAccessDAO");
    const dao = await DAO.deploy();
    await dao.createProposal("Allow patient access");
    await dao.vote(0, true);
    const result = await dao.execute(0);
    expect(result).to.equal("Proposal PASSED");
  });
});
