// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract TariffForgivenessRouter {
    address public steward;

    struct TariffEvent {
        string country;
        string sector;
        uint256 tariffRate;
        bool forgiven;
        uint256 timestamp;
    }

    TariffEvent[] public events;

    event TariffLogged(string country, string sector, uint256 tariffRate, bool forgiven, uint256 timestamp);
    event TariffForgiven(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTariffEvent(
        string memory country,
        string memory sector,
        uint256 tariffRate
    ) public {
        events.push(TariffEvent(country, sector, tariffRate, false, block.timestamp));
        emit TariffLogged(country, sector, tariffRate, false, block.timestamp);
    }

    function forgiveTariff(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].forgiven = true;
        emit TariffForgiven(index, msg.sender);
    }

    function getTariffEvent(uint256 index) public view returns (
        string memory, string memory, uint256, bool, uint256
    ) {
        TariffEvent memory e = events[index];
        return (e.country, e.sector, e.tariffRate, e.forgiven, e.timestamp);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
