// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/community/PermitRegistry.sol";
import "../contracts/community/ResourceStewardshipEscrow.sol";
import "../contracts/community/LocalRevenueGuard.sol";
import "../contracts/community/LocalHireConditional.sol";
import "../contracts/community/CommunityDAO.sol";

contract DeployCommunity is Script {
    function run() external {
        vm.startBroadcast();

        PermitRegistry registry = new PermitRegistry();
        ResourceStewardshipEscrow escrow = new ResourceStewardshipEscrow();
        LocalRevenueGuard revenue = new LocalRevenueGuard(address(0x123), address(0x456));
        LocalHireConditional hire = new LocalHireConditional();

        address[] memory members = new address[](1);
        members[0] = 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A;
        CommunityDAO dao = new CommunityDAO(members);

        console.log("PermitRegistry deployed at:", address(registry));
        console.log("ResourceStewardshipEscrow deployed at:", address(escrow));
        console.log("LocalRevenueGuard deployed at:", address(revenue));
        console.log("LocalHireConditional deployed at:", address(hire));
        console.log("CommunityDAO deployed at:", address(dao));

        vm.stopBroadcast();
    }
}
