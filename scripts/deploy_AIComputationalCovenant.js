const hre = require("hardhat");

async function main() {
  const Covenant = await hre.ethers.getContractFactory("AIComputationalCovenant");
  const covenant = await Covenant.deploy();

  await covenant.deployed();

  console.log("AIComputationalCovenant deployed to:", covenant.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
