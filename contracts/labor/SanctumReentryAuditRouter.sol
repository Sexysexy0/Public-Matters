// SPDX-License-Identifier: SanctumReentryAudit-License
pragma solidity ^0.8.0;

contract SanctumReentryAuditRouter {
    address public steward;

    struct ReentrySignal {
        string sanctumID;
        string commodity;
        bool reentryConfirmed;
        string continuityStatus;
        uint256 timestamp;
    }

    ReentrySignal[] public signals;

    event SanctumReentryAudited(string sanctumID, string commodity, bool reentryConfirmed, string continuityStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditReentry(string memory sanctumID, string memory commodity, bool reentryConfirmed, string memory continuityStatus) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(ReentrySignal(sanctumID, commodity, reentryConfirmed, continuityStatus, block.timestamp));
        emit SanctumReentryAudited(sanctumID, commodity, reentryConfirmed, continuityStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ReentrySignal memory s = signals[index];
        return (s.sanctumID, s.commodity, s.reentryConfirmed, s.continuityStatus, s.timestamp);
    }
}
