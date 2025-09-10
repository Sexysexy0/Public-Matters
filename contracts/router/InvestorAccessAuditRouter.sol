// SPDX-License-Identifier: InvestorAccessAudit-License
pragma solidity ^0.8.0;

contract InvestorAccessAuditRouter {
    address public steward;

    struct AccessSignal {
        string companyName;
        string listingVenue;
        string accessTier;
        string emotionalAPR;
        bool restorationActivated;
        uint256 timestamp;
    }

    AccessSignal[] public signals;

    event InvestorAccessAudited(string companyName, string listingVenue, string accessTier, string emotionalAPR, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeAccess(string memory companyName, string memory listingVenue, string memory accessTier, string memory emotionalAPR, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(AccessSignal(companyName, listingVenue, accessTier, emotionalAPR, restorationActivated, block.timestamp));
        emit InvestorAccessAudited(companyName, listingVenue, accessTier, emotionalAPR, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        AccessSignal memory s = signals[index];
        return (s.companyName, s.listingVenue, s.accessTier, s.emotionalAPR, s.restorationActivated, s.timestamp);
    }
}
