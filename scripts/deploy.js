// scripts/deploy.js
import { ethers } from "hardhat";
import fs from "fs";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy HempAccessDAO
  const HempDAO = await ethers.getContractFactory("HempAccessDAO");
  const hempDAO = await HempDAO.deploy();
  await hempDAO.waitForDeployment();
  const hempDAOAddress = await hempDAO.getAddress();
  console.log("HempAccessDAO deployed at:", hempDAOAddress);

  // Deploy PatientRightsNFT
  const PatientNFT = await ethers.getContractFactory("PatientRightsNFT");
  const patientNFT = await PatientNFT.deploy();
  await patientNFT.waitForDeployment();
  const patientNFTAddress = await patientNFT.getAddress();
  console.log("PatientRightsNFT deployed at:", patientNFTAddress);

  // Deploy MarketTransparencyVault
  const Vault = await ethers.getContractFactory("MarketTransparencyVault");
  const vault = await Vault.deploy();
  await vault.waitForDeployment();
  const vaultAddress = await vault.getAddress();
  console.log("MarketTransparencyVault deployed at:", vaultAddress);

  // Save deployments to file
  const deployments = {
    HempAccessDAO: hempDAOAddress,
    PatientRightsNFT: patientNFTAddress,
    MarketTransparencyVault: vaultAddress
  };

  fs.writeFileSync("deployments.json", JSON.stringify(deployments, null, 2));
  console.log("Saved deployments.json");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
