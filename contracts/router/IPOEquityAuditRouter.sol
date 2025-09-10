// SPDX-License-Identifier: IPOEquityAudit-License
pragma solidity ^0.8.0;

contract IPOEquityAuditRouter {
    address public steward;

    struct AuditSignal {
        string companyName;
        string listingRegion;
        string exemptionType;
        string emotionalAPR;
        bool restorationActivated;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event IPOEquityAudited(string companyName, string listingRegion, string exemptionType, string emotionalAPR, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeAudit(string memory companyName, string memory listingRegion, string memory exemptionType, string memory emotionalAPR, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(AuditSignal(companyName, listingRegion, exemptionType, emotionalAPR, restorationActivated, block.timestamp));
        emit IPOEquityAudited(companyName, listingRegion, exemptionType, emotionalAPR, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        AuditSignal memory s = signals[index];
        return (s.companyName, s.listingRegion, s.exemptionType, s.emotionalAPR, s.restorationActivated, s.timestamp);
    }
}
