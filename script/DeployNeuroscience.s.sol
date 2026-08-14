// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/neuroscience/StudyDesignRegistry.sol";
import "../contracts/neuroscience/DataIntegrityLedger.sol";
import "../contracts/neuroscience/AnalysisCodex.sol";
import "../contracts/neuroscience/ReputationToken.sol";
import "../contracts/neuroscience/PeerReviewOracle.sol";

contract DeployNeuroscience is Script {
    function run() external {
        vm.startBroadcast();

        StudyDesignRegistry registry = new StudyDesignRegistry();
        DataIntegrityLedger ledger = new DataIntegrityLedger();
        AnalysisCodex codex = new AnalysisCodex();
        ReputationToken token = new ReputationToken();
        PeerReviewOracle oracle = new PeerReviewOracle();

        console.log("StudyDesignRegistry deployed at:", address(registry));
        console.log("DataIntegrityLedger deployed at:", address(ledger));
        console.log("AnalysisCodex deployed at:", address(codex));
        console.log("ReputationToken deployed at:", address(token));
        console.log("PeerReviewOracle deployed at:", address(oracle));

        vm.stopBroadcast();
    }
}
