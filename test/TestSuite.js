const { expect } = require("chai");

describe("HumanSkillRegistry", function () {
  it("Should register a skill", async function () {
    const [owner] = await ethers.getSigners();
    const Skill = await ethers.getContractFactory("HumanSkillRegistry");
    const skill = await Skill.deploy();
    await skill.registerSkill("Plumber");
    const skills = await skill.getSkills(owner.address);
    expect(skills.length).to.equal(1);
  });
});
