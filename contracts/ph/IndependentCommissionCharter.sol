// IndependentCommissionCharter.sol
pragma solidity ^0.8.19;

contract IndependentCommissionCharter {
    address public steward;

    struct AuditEntry {
        string department;
        string reportLink;
        uint256 timestamp;
        bool verified;
    }

    AuditEntry[] public audits;

    event AuditLogged(string department, string reportLink);
    event AuditVerified(string department);

    constructor() {
        steward = msg.sender;
    }

    function logAudit(string memory department, string memory reportLink) public {
        audits.push(AuditEntry(department, reportLink, block.timestamp, false));
        emit AuditLogged(department, reportLink);
    }

    function verifyAudit(uint index) public {
        require(msg.sender == steward, "Only steward may verify");
        audits[index].verified = true;
        emit AuditVerified(audits[index].department);
    }

    function getAudits() public view returns (AuditEntry[] memory) {
        return audits;
    }
}
