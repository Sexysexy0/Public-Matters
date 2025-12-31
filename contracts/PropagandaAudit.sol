// contracts/PropagandaAudit.sol
pragma solidity ^0.8.20;

/**
 * @title PropagandaAudit
 * @notice Logs audits of propaganda and disinformation campaigns.
 */
contract PropagandaAudit {
    address public admin;

    struct Audit {
        string source;      // "StateMedia", "SocialPlatform"
        string finding;
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string source, string finding, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logAudit(string calldata source, string calldata finding) external onlyAdmin {
        audits.push(Audit(source, finding, block.timestamp));
        emit AuditLogged(source, finding, block.timestamp);
    }
}
