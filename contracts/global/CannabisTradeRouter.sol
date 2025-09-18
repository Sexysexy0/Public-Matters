// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract CannabisTradeRouter {
    address public steward;

    struct TradeSignal {
        string origin; // e.g. "Bulacan", "Metro Manila", "Thailand"
        string destination; // e.g. "Cebu", "California", "Japan"
        string cargoType; // "Medicinal Buds", "Oils", "Tinctures"
        string blessingStatus; // "Scrollchain-Certified", "Pending", "Denied"
        bool verified;
        uint256 timestamp;
    }

    TradeSignal[] public signals;

    event TradeLogged(string origin, string destination, string cargoType, string blessingStatus, uint256 timestamp);
    event TradeVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTrade(
        string memory origin,
        string memory destination,
        string memory cargoType,
        string memory blessingStatus
    ) public {
        signals.push(TradeSignal(origin, destination, cargoType, blessingStatus, false, block.timestamp));
        emit TradeLogged(origin, destination, cargoType, blessingStatus, block.timestamp);
    }

    function verifyTrade(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit TradeVerified(index, msg.sender);
    }

    function getTrade(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        TradeSignal memory t = signals[index];
        return (t.origin, t.destination, t.cargoType, t.blessingStatus, t.timestamp);
    }

    function totalTradeSignals() public view returns (uint256) {
        return signals.length;
    }
}
