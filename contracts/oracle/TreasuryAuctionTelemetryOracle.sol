// SPDX-License-Identifier: TreasuryAuctionTelemetry-License
pragma solidity ^0.8.0;

contract TreasuryAuctionTelemetryOracle {
    address public steward;

    struct AuctionPulse {
        string instrument;
        string auctionDate;
        string clauseActivated;
        bool liquidityImpact;
        uint256 timestamp;
    }

    AuctionPulse[] public pulses;

    event AuctionPulseEmitted(string instrument, string auctionDate, string clauseActivated, bool liquidityImpact, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory instrument, string memory auctionDate, string memory clauseActivated, bool liquidityImpact) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(AuctionPulse(instrument, auctionDate, clauseActivated, liquidityImpact, block.timestamp));
        emit AuctionPulseEmitted(instrument, auctionDate, clauseActivated, liquidityImpact, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        AuctionPulse memory p = pulses[index];
        return (p.instrument, p.auctionDate, p.clauseActivated, p.liquidityImpact, p.timestamp);
    }
}
