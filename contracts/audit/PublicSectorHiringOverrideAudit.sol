// SPDX-License-Identifier: PublicSectorHiringOverrideAudit-License
pragma solidity ^0.8.0;

contract PublicSectorHiringOverrideAudit {
    address public steward;

    struct OverrideSignal {
        string agencyID;
        string region;
        bool overrideDetected;
        string overrideType;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event HiringOverrideAudited(string agencyID, string region, bool overrideDetected, string overrideType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditOverride(string memory agencyID, string memory region, bool overrideDetected, string memory overrideType) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(OverrideSignal(agencyID, region, overrideDetected, overrideType, block.timestamp));
        emit HiringOverrideAudited(agencyID, region, overrideDetected, overrideType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.agencyID, s.region, s.overrideDetected, s.overrideType, s.timestamp);
    }
}
