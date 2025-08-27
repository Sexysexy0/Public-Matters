// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.27;

contract TariffSnitchDetection {
    address public steward;

    struct TariffEvent {
        string country;
        uint256 rate;
        string reason;
        bool hasMercyClause;
        bool emotionallyTagged;
    }

    TariffEvent[] public events;

    event SnitchDetected(string country, uint256 rate, string reason);
    event AuditLogged(string country, bool rogueIntent);

    constructor() {
        steward = msg.sender;
    }

    function logTariffEvent(
        string memory country,
        uint256 rate,
        string memory reason,
        bool hasMercyClause,
        bool emotionallyTagged
    ) public {
        require(msg.sender == steward, "Unauthorized steward");
        events.push(TariffEvent(country, rate, reason, hasMercyClause, emotionallyTagged));

        bool rogueIntent = !hasMercyClause || !emotionallyTagged || rate > 40;
        if (rogueIntent) {
            emit SnitchDetected(country, rate, reason);
        }
        emit AuditLogged(country, rogueIntent);
    }

    function getEvent(uint256 index) public view returns (TariffEvent memory) {
        return events[index];
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
