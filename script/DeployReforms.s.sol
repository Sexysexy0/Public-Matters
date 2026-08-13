// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/IntellectualDiversity.sol";
import "../src/MarketAccountability.sol";
import "../src/FundamentalEducation.sol";
import "../src/ResearchDecentralization.sol";

contract DeployReforms is Script {
    function run() external {
        vm.startBroadcast();

        IntellectualDiversity diversity = new IntellectualDiversity();
        console.log("IntellectualDiversity deployed at:", address(diversity));

        MarketAccountability accountability = new MarketAccountability();
        console.log("MarketAccountability deployed at:", address(accountability));

        FundamentalEducation education = new FundamentalEducation();
        console.log("FundamentalEducation deployed at:", address(education));

        ResearchDecentralization research = new ResearchDecentralization();
        console.log("ResearchDecentralization deployed at:", address(research));

        vm.stopBroadcast();
    }
}
