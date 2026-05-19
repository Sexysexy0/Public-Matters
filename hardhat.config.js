import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-toolbox";

// Safety fallback logic para sa local compilation security
const SEPOLIA_KEY = process.env.PRIVATE_KEY || "0x0000000000000000000000000000000000000000000000000000000000000001";
const INFURA_KEY = process.env.INFURA_API_KEY || "dummy-key";

export default {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_KEY}`,
      accounts: [SEPOLIA_KEY]
    }
  }
};

