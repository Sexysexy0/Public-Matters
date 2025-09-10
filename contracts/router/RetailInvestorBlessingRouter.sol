// SPDX-License-Identifier: RetailInvestorBlessing-License
pragma solidity ^0.8.0;

contract RetailInvestorBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string investorID;
        string equityAccess;
        bool dividendReceived;
        string emotionalAPR;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event RetailInvestorBlessed(string investorID, string equityAccess, bool dividendReceived, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessInvestor(string memory investorID, string memory equityAccess, bool dividendReceived, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can bless");
        signals.push(BlessingSignal(investorID, equityAccess, dividendReceived, emotionalAPR, block.timestamp));
        emit RetailInvestorBlessed(investorID, equityAccess, dividendReceived, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.investorID, s.equityAccess, s.dividendReceived, s.emotionalAPR, s.timestamp);
    }
}
