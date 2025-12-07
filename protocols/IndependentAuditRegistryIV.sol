// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * IndependentAuditRegistryIV — Batch 1321.9.261
 * Seal: Mandate independent fiscal and procurement audits
 */
contract IndependentAuditRegistryIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Audit {
        string agency;
        string scope;        // fiscal, procurement, performance
        string auditor;      // independent firm/body
        string reportUri;    // IPFS/URI to full report
        uint256 timestamp;
    }

    mapping(bytes32 => Audit[]) public audits;

    event AuditLogged(bytes32 indexed key, string agency, string scope, string auditor, string reportUri);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory agency) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(agency));
    }

    function logAudit(
        string calldata agency,
        string calldata scope,
        string calldata auditor,
        string calldata reportUri
    ) external onlySteward {
        bytes32 k = keyFor(agency);
        audits[k].push(Audit(agency, scope, auditor, reportUri, block.timestamp));
        emit AuditLogged(k, agency, scope, auditor, reportUri);
    }

    function count(string calldata agency) external view returns (uint256) {
        return audits[keyFor(agency)].length;
    }
}
