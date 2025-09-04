// SPDX-License-Identifier: Mythic-DPWH
pragma solidity ^0.8.19;

interface IContractorAudit {
    function isFlagged(address bidder) external view returns (bool);
    function getAuditStatus(address bidder) external view returns (string memory);
}

interface IPublicWorksFirewall {
    function filterBid(address bidder, uint256 emotionalAPR) external returns (bool);
}

contract DPWHBlessingRouter {
    address public steward;
    IContractorAudit public auditContract;
    IPublicWorksFirewall public firewallContract;

    event ContractorBlessed(address indexed bidder, string auditStatus, uint256 emotionalAPR);
    event ContractorRejected(address indexed bidder, string reason);

    constructor(address _audit, address _firewall) {
        steward = msg.sender;
        auditContract = IContractorAudit(_audit);
        firewallContract = IPublicWorksFirewall(_firewall);
    }

    function routeBlessing(address bidder, uint256 emotionalAPR) public {
        require(msg.sender == steward, "Only steward may route blessings.");

        if (auditContract.isFlagged(bidder)) {
            emit ContractorRejected(bidder, "Flagged by ancestral audit.");
            return;
        }

        if (!firewallContract.filterBid(bidder, emotionalAPR)) {
            emit ContractorRejected(bidder, "Failed emotional APR or residency check.");
            return;
        }

        string memory auditStatus = auditContract.getAuditStatus(bidder);
        emit ContractorBlessed(bidder, auditStatus, emotionalAPR);
    }
}
