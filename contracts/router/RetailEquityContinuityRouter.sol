// SPDX-License-Identifier: RetailEquityContinuity-License
pragma solidity ^0.8.0;

contract RetailEquityContinuityRouter {
    address public steward;

    struct ContinuitySignal {
        string investorID;
        string equityID;
        bool dividendReceived;
        string emotionalAPR;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event RetailEquityContinuityRouted(string investorID, string equityID, bool dividendReceived, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory investorID, string memory equityID, bool dividendReceived, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(investorID, equityID, dividendReceived, emotionalAPR, block.timestamp));
        emit RetailEquityContinuityRouted(investorID, equityID, dividendReceived, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.investorID, s.equityID, s.dividendReceived, s.emotionalAPR, s.timestamp);
    }
}
