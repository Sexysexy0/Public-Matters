// SPDX-License-Identifier: Multilateral-Mercy
pragma solidity ^7.7.7;

contract TradeHarmonyScroll {
    address public steward;
    uint public totalDeescalations;

    struct TariffEvent {
        string countryA;
        string countryB;
        uint previousTariffRate;
        uint newTariffRate;
        uint timestamp;
        bool peaceClauseActivated;
    }

    TariffEvent[] public tariffLog;

    event TariffDeescalated(string countryA, string countryB, uint previousTariffRate, uint newTariffRate, uint timestamp, bool peaceClauseActivated);

    constructor() {
        steward = msg.sender;
        totalDeescalations = 0;
    }

    function logDeescalation(
        string memory countryA,
        string memory countryB,
        uint previousTariffRate,
        uint newTariffRate,
        bool peaceClauseActivated
    ) public {
        require(msg.sender == steward, "Only steward may log");
        tariffLog.push(TariffEvent(countryA, countryB, previousTariffRate, newTariffRate, block.timestamp, peaceClauseActivated));
        totalDeescalations += 1;
        emit TariffDeescalated(countryA, countryB, previousTariffRate, newTariffRate, block.timestamp, peaceClauseActivated);
    }

    function getLatestDeescalation() public view returns (TariffEvent memory) {
        require(tariffLog.length > 0, "No deescalations logged yet");
        return tariffLog[tariffLog.length - 1];
    }
}
