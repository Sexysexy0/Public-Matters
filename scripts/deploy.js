async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const Skill = await ethers.getContractFactory("HumanSkillRegistry");
  const skill = await Skill.deploy();
  console.log("HumanSkillRegistry deployed at:", skill.address);

  const MediaDAO = await ethers.getContractFactory("AlgorithmicMediaDAO");
  const mediaDAO = await MediaDAO.deploy();
  console.log("AlgorithmicMediaDAO deployed at:", mediaDAO.address);

  const Vault = await ethers.getContractFactory("AIUtilityVault");
  const vault = await Vault.deploy();
  console.log("AIUtilityVault deployed at:", vault.address);

  const Registry = await ethers.getContractFactory("ContractRegistry");
  const registry = await Registry.deploy();
  console.log("ContractRegistry deployed at:", registry.address);

  await registry.register("HumanSkillRegistry", skill.address);
  await registry.register("AlgorithmicMediaDAO", mediaDAO.address);
  await registry.register("AIUtilityVault", vault.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
