// SPDX-License-Identifier: GlobalTechEquity-License
pragma solidity ^0.8.0;

contract GlobalTechEquityRouter {
    address public steward;

    struct EquitySignal {
        string companyName;
        string listingVenue;
        string accessTier;
        string emotionalAPR;
        uint256 timestamp;
    }

    EquitySignal[] public signals;

    event TechEquityRouted(string companyName, string listingVenue, string accessTier, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeEquity(string memory companyName, string memory listingVenue, string memory accessTier, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(EquitySignal(companyName, listingVenue, accessTier, emotionalAPR, block.timestamp));
        emit TechEquityRouted(companyName, listingVenue, accessTier, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        EquitySignal memory s = signals[index];
        return (s.companyName, s.listingVenue, s.accessTier, s.emotionalAPR, s.timestamp);
    }
}
