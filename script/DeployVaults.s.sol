// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ScholarshipEscrow.sol";
import "../src/HospitalClaimEscrow.sol";
import "../src/MicroLendingEscrow.sol";
import "../src/MultiSigEscrowVault.sol";
import "../src/ProjectMilestoneEscrow.sol";
import "../src/FairPriceBudgetVault.sol";
import "../src/CommunityFloodVault.sol";
import "../src/AntiCorruptionWhistleblowerVault.sol";

contract DeployVaults is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address admin = vm.envAddress("WALLET_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        ScholarshipEscrow scholarship = new ScholarshipEscrow(admin);
        HospitalClaimEscrow hospital = new HospitalClaimEscrow(admin);

        MicroLendingEscrow micro = new MicroLendingEscrow(
            5, // example baseInterestRate (uint256)
            admin
        );

        // Single signer multisig (threshold = 1)
        address[] memory signers = new address[](1);
        signers[0] = admin;
        MultiSigEscrowVault multisig = new MultiSigEscrowVault(signers, 1);

        ProjectMilestoneEscrow milestone = new ProjectMilestoneEscrow(admin);
        FairPriceBudgetVault fairprice = new FairPriceBudgetVault(1000 ether);
        CommunityFloodVault flood = new CommunityFloodVault(admin);
        AntiCorruptionWhistleblowerVault whistle = new AntiCorruptionWhistleblowerVault();

        vm.stopBroadcast();

        console.log("ScholarshipEscrow deployed at:", address(scholarship));
        console.log("HospitalClaimEscrow deployed at:", address(hospital));
        console.log("MicroLendingEscrow deployed at:", address(micro));
        console.log("MultiSigEscrowVault deployed at:", address(multisig));
        console.log("ProjectMilestoneEscrow deployed at:", address(milestone));
        console.log("FairPriceBudgetVault deployed at:", address(fairprice));
        console.log("CommunityFloodVault deployed at:", address(flood));
        console.log("AntiCorruptionWhistleblowerVault deployed at:", address(whistle));
    }
}
