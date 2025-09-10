// SPDX-License-Identifier: DividendBlessing-License
pragma solidity ^0.8.0;

contract DividendBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string investorID;
        string equityID;
        bool dividendReceived;
        string emotionalAPR;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event DividendBlessed(string investorID, string equityID, bool dividendReceived, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessDividend(string memory investorID, string memory equityID, bool dividendReceived, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can bless");
        signals.push(BlessingSignal(investorID, equityID, dividendReceived, emotionalAPR, block.timestamp));
        emit DividendBlessed(investorID, equityID, dividendReceived, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.investorID, s.equityID, s.dividendReceived, s.emotionalAPR, s.timestamp);
    }
}
