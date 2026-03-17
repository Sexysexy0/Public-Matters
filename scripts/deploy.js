async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const HempDAO = await ethers.getContractFactory("HempAccessDAO");
  const hempDAO = await HempDAO.deploy();
  console.log("HempAccessDAO deployed at:", hempDAO.address);

  const PatientNFT = await ethers.getContractFactory("PatientRightsNFT");
  const patientNFT = await PatientNFT.deploy();
  console.log("PatientRightsNFT deployed at:", patientNFT.address);

  const Vault = await ethers.getContractFactory("MarketTransparencyVault");
  const vault = await Vault.deploy();
  console.log("MarketTransparencyVault deployed at:", vault.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
