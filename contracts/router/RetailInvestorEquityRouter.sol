// SPDX-License-Identifier: RetailInvestorEquity-License
pragma solidity ^0.8.0;

contract RetailInvestorEquityRouter {
    address public steward;

    struct EquitySignal {
        string investorID;
        string equityID;
        string accessTier;
        string emotionalAPR;
        uint256 timestamp;
    }

    EquitySignal[] public signals;

    event RetailEquityRouted(string investorID, string equityID, string accessTier, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeEquity(string memory investorID, string memory equityID, string memory accessTier, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(EquitySignal(investorID, equityID, accessTier, emotionalAPR, block.timestamp));
        emit RetailEquityRouted(investorID, equityID, accessTier, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        EquitySignal memory s = signals[index];
        return (s.investorID, s.equityID, s.accessTier, s.emotionalAPR, s.timestamp);
    }
}
