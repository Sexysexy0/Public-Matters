// SPDX-License-Identifier: RetailSanctumEquity-License
pragma solidity ^0.8.0;

contract RetailSanctumEquityRouter {
    address public steward;

    struct EquitySignal {
        string investorID;
        string sanctumName;
        string accessTier;
        string emotionalAPR;
        uint256 timestamp;
    }

    EquitySignal[] public signals;

    event RetailSanctumEquityRouted(string investorID, string sanctumName, string accessTier, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeEquity(string memory investorID, string memory sanctumName, string memory accessTier, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(EquitySignal(investorID, sanctumName, accessTier, emotionalAPR, block.timestamp));
        emit RetailSanctumEquityRouted(investorID, sanctumName, accessTier, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        EquitySignal memory s = signals[index];
        return (s.investorID, s.sanctumName, s.accessTier, s.emotionalAPR, s.timestamp);
    }
}
