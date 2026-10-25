// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {CandidateCommitmentRegistry} from "../src/candidate-commitments/CandidateCommitmentRegistry.sol";

contract DeployCandidateCommitmentRegistry is Script {
    function run() external returns (CandidateCommitmentRegistry registry) {
        vm.startBroadcast();
        registry = new CandidateCommitmentRegistry();
        vm.stopBroadcast();

        console.log("CandidateCommitmentRegistry deployed at:", address(registry));
    }
}
