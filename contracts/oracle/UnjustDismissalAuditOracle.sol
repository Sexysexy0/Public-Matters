// SPDX-License-Identifier: UnjustDismissalAudit-License
pragma solidity ^0.8.0;

contract UnjustDismissalAuditOracle {
    address public steward;

    struct DismissalSignal {
        string stewardID;
        string originSanctum;
        bool dismissalAttempted;
        string breachType;
        uint256 timestamp;
    }

    DismissalSignal[] public signals;

    event DismissalAudited(string stewardID, string originSanctum, bool dismissalAttempted, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditDismissal(string memory stewardID, string memory originSanctum, bool dismissalAttempted, string memory breachType) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(DismissalSignal(stewardID, originSanctum, dismissalAttempted, breachType, block.timestamp));
        emit DismissalAudited(stewardID, originSanctum, dismissalAttempted, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        DismissalSignal memory s = signals[index];
        return (s.stewardID, s.originSanctum, s.dismissalAttempted, s.breachType, s.timestamp);
    }
}
