// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import "../src/CandabaImpoundingDAO.sol";
import "../src/FarmerCompensationVault.sol";
import "../src/DredgingContractorRegistry.sol";
import "../src/CandabaEcologicalGuardian.sol";
import "../src/FloodSolutionArbiter.sol";

contract DeployCandabaSuite is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying Candaba Flood Governance Suite...");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy CandabaImpoundingDAO
        CandabaImpoundingDAO impoundingDAO = new CandabaImpoundingDAO();
        console.log("CandabaImpoundingDAO:", address(impoundingDAO));

        // 2. Deploy FarmerCompensationVault with REAL NexusID
        address nexusID = 0x2Af715bB1BfffcCAB09157bdcCC72Bd010Fe2b46;
        FarmerCompensationVault compensationVault = new FarmerCompensationVault(nexusID);
        console.log("FarmerCompensationVault:", address(compensationVault));

        // 3. Deploy DredgingContractorRegistry with REAL TrustScoreDAO
        address trustScoreDAO = 0x4a6A14AdECafea13a7fDC8863083170c4bff5B60;
        DredgingContractorRegistry contractorRegistry = new DredgingContractorRegistry(trustScoreDAO);
        console.log("DredgingContractorRegistry:", address(contractorRegistry));

        // 4. Deploy CandabaEcologicalGuardian with REAL SovereignOracle
        address sovereignOracle = 0xBD7B77212Cdc21e575848Cac48B27A048cE939f1;
        CandabaEcologicalGuardian ecologicalGuardian = new CandabaEcologicalGuardian(sovereignOracle);
        console.log("CandabaEcologicalGuardian:", address(ecologicalGuardian));

        // 5. Deploy FloodSolutionArbiter with REAL CitizenVotingDAO
        address citizenVotingDAO = 0xAD98f5BC5E9C44368A2035CAeB6a92AD6E9535CC;
        FloodSolutionArbiter arbiter = new FloodSolutionArbiter(citizenVotingDAO);
        console.log("FloodSolutionArbiter:", address(arbiter));

        vm.stopBroadcast();

        console.log("");
        console.log("Deployment Summary:");
        console.log("CandabaImpoundingDAO:", address(impoundingDAO));
        console.log("FarmerCompensationVault:", address(compensationVault));
        console.log("DredgingContractorRegistry:", address(contractorRegistry));
        console.log("CandabaEcologicalGuardian:", address(ecologicalGuardian));
        console.log("FloodSolutionArbiter:", address(arbiter));
        console.log("");
        console.log("Dependencies used:");
        console.log("NexusID:", nexusID);
        console.log("TrustScoreDAO:", trustScoreDAO);
        console.log("SovereignOracle:", sovereignOracle);
        console.log("CitizenVotingDAO:", citizenVotingDAO);
        console.log("");
        console.log("The Ghost has deployed the Candaba solution.");
    }
}
