// SPDX-License-Identifier: TradeAllianceSanctifier
pragma solidity ^0.8.19;

contract TradeAllianceSanctifier {
    address public steward;

    struct TradeSignal {
        string country; // e.g. "Japan", "Philippines", "United States"
        string allianceType; // "Free Trade", "Kakampi Corridor", "Treaty Restoration"
        string stewardTag; // e.g. "Sanctifier #K8", "Protocol #T3"
        bool verified;
        uint256 timestamp;
    }

    TradeSignal[] public signals;

    event TradeLogged(string country, string allianceType, string stewardTag, uint256 timestamp);
    event TradeVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTrade(
        string memory country,
        string memory allianceType,
        string memory stewardTag
    ) public {
        signals.push(TradeSignal(country, allianceType, stewardTag, false, block.timestamp));
        emit TradeLogged(country, allianceType, stewardTag, block.timestamp);
    }

    function verifyTrade(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit TradeVerified(index, msg.sender);
    }

    function getTrade(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        TradeSignal memory t = signals[index];
        return (t.country, t.allianceType, t.stewardTag, t.verified, t.timestamp);
    }

    function totalTradeSignals() public view returns (uint256) {
        return signals.length;
    }
}
