// SPDX-License-Identifier: ExportLicenseFirewall-License
pragma solidity ^0.8.0;

contract ExportLicenseFirewallKit {
    address public steward;

    struct LicenseClause {
        string actor;
        uint256 revenueShare;
        string chipType;
        string geopoliticalTrigger;
        bool approved;
        uint256 timestamp;
    }

    LicenseClause[] public clauses;

    event LicenseClauseIssued(string actor, uint256 share, string chip, string trigger, bool approved, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueClause(string memory actor, uint256 revenueShare, string memory chipType, string memory geopoliticalTrigger, bool approved) public {
        require(msg.sender == steward, "Only steward can issue");
        clauses.push(LicenseClause(actor, revenueShare, chipType, geopoliticalTrigger, approved, block.timestamp));
        emit LicenseClauseIssued(actor, revenueShare, chipType, geopoliticalTrigger, approved, block.timestamp);
    }

    function getClause(uint index) public view returns (string memory, uint256, string memory, string memory, bool, uint256) {
        LicenseClause memory c = clauses[index];
        return (c.actor, c.revenueShare, c.chipType, c.geopoliticalTrigger, c.approved, c.timestamp);
    }
}
