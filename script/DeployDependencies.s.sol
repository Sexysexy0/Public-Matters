// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import "../src/NexusID.sol";
import "../src/TrustScoreDAO.sol";
import "../src/SovereignOracle.sol";
import "../src/CitizenVotingDAO.sol";

contract DeployDependencies is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying Dependencies...");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        NexusID nexusID = new NexusID();
        console.log("NexusID:", address(nexusID));

        TrustScoreDAO trustScore = new TrustScoreDAO();
        console.log("TrustScoreDAO:", address(trustScore));

        SovereignOracle oracle = new SovereignOracle();
        console.log("SovereignOracle:", address(oracle));

        CitizenVotingDAO citizenVoting = new CitizenVotingDAO();
        console.log("CitizenVotingDAO:", address(citizenVoting));

        vm.stopBroadcast();

        console.log("");
        console.log("Dependency Addresses:");
        console.log("NexusID:", address(nexusID));
        console.log("TrustScoreDAO:", address(trustScore));
        console.log("SovereignOracle:", address(oracle));
        console.log("CitizenVotingDAO:", address(citizenVoting));
    }
}
