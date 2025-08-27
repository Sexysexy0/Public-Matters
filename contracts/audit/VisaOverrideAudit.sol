// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.27;

contract VisaOverrideAudit {
    address public steward;

    struct VisaEvent {
        string country;
        uint256 volume;
        string reason;
        bool tradeLinked;
        bool emotionallyTagged;
    }

    VisaEvent[] public events;

    event OverrideDetected(string country, uint256 volume, string reason);
    event AuditLogged(string country, bool overrideIntent);

    constructor() {
        steward = msg.sender;
    }

    function logVisaEvent(
        string memory country,
        uint256 volume,
        string memory reason,
        bool tradeLinked,
        bool emotionallyTagged
    ) public {
        require(msg.sender == steward, "Unauthorized steward");
        events.push(VisaEvent(country, volume, reason, tradeLinked, emotionallyTagged));

        bool overrideIntent = tradeLinked && !emotionallyTagged;
        if (overrideIntent) {
            emit OverrideDetected(country, volume, reason);
        }
        emit AuditLogged(country, overrideIntent);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
