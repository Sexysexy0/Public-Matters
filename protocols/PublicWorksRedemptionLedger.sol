// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksRedemptionLedger {
    address public steward;

    struct RedemptionEntry {
        string projectName;
        string redemptionMechanism;
        string communitySignal;
        string emotionalTag;
    }

    RedemptionEntry[] public ledger;

    event PublicWorkRedeemed(string projectName, string redemptionMechanism, string communitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function redeemPublicWork(
        string memory projectName,
        string memory redemptionMechanism,
        string memory communitySignal,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(RedemptionEntry(projectName, redemptionMechanism, communitySignal, emotionalTag));
        emit PublicWorkRedeemed(projectName, redemptionMechanism, communitySignal, emotionalTag);
    }
}
