// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "./BitMarketBudgetSanctumRouter.sol";

contract BitMarketBlessingAutoDeploy {
    BitMarketBudgetSanctumRouter public router;
    address public steward;
    uint public aprThreshold = 90;

    event AutoBlessingDeployed(string barangay, string domain, uint aprScore, uint amount);

    constructor(address routerAddress) {
        router = BitMarketBudgetSanctumRouter(routerAddress);
        steward = msg.sender;
    }

    function autoDeployBlessing(
        string memory barangay,
        string memory signalType,
        uint aprScore,
        uint amount
    ) public {
        require(aprScore >= aprThreshold, "APR too low for auto-blessing");
        string memory destination = router.routeSignal(signalType);
        emit AutoBlessingDeployed(barangay, destination, aprScore, amount);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        aprThreshold = newThreshold;
    }
}
