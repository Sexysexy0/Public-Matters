// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BluntAdvice.sol";
import "../src/CommandFeedback.sol";
import "../src/HistoryLightedPath.sol";
import "../src/PoliticalEndstate.sol";
import "../src/DiplomaticNuance.sol";

contract LeadershipSuiteDeploy is Script {
    function run() external {
        vm.startBroadcast();

        BluntAdvice advice = new BluntAdvice();
        CommandFeedback feedback = new CommandFeedback();
        HistoryLightedPath history = new HistoryLightedPath();
        PoliticalEndstate endstate = new PoliticalEndstate();
        DiplomaticNuance nuance = new DiplomaticNuance();

        console.log("BluntAdvice deployed at:", address(advice));
        console.log("CommandFeedback deployed at:", address(feedback));
        console.log("HistoryLightedPath deployed at:", address(history));
        console.log("PoliticalEndstate deployed at:", address(endstate));
        console.log("DiplomaticNuance deployed at:", address(nuance));

        vm.stopBroadcast();
    }
}
