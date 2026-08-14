// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FundamentalEducation.sol";
import "../src/IntellectualDiversity.sol";
import "../src/MarketAccountability.sol";
import "../src/ResearchDecentralization.sol";

/// @title Deploy Reforms Bundle
/// @notice Deploys the four reform contracts to Sepolia
contract DeployReforms is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        FundamentalEducation education = new FundamentalEducation();
        IntellectualDiversity diversity = new IntellectualDiversity();
        MarketAccountability accountability = new MarketAccountability();
        ResearchDecentralization research = new ResearchDecentralization();

        vm.stopBroadcast();

        console.log("FundamentalEducation deployed at:", address(education));
        console.log("IntellectualDiversity deployed at:", address(diversity));
        console.log("MarketAccountability deployed at:", address(accountability));
        console.log("ResearchDecentralization deployed at:", address(research));
    }
}
