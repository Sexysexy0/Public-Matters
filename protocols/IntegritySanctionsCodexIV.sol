// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * IntegritySanctionsCodexIV — Batch 1321.9.261
 * Seal: Enforce sanctions for corrupt or self-dealing conduct
 */
contract IntegritySanctionsCodexIV {
    address public steward;
    uint256 public version = 1321_9_261;

    enum SanctionType { Warning, Suspension, Removal, Restitution }

    struct Sanction {
        string subjectId;
        SanctionType kind;
        string basis;      // conflict, graft, self-dealing, malversation
        string orderUri;   // formal order / case citation
        uint256 timestamp;
    }

    mapping(bytes32 => Sanction[]) public sanctions;

    event SanctionIssued(bytes32 indexed key, string subjectId, SanctionType kind, string basis, string orderUri);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory subjectId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(subjectId));
    }

    function issueSanction(
        string calldata subjectId,
        SanctionType kind,
        string calldata basis,
        string calldata orderUri
    ) external onlySteward {
        bytes32 k = keyFor(subjectId);
        sanctions[k].push(Sanction(subjectId, kind, basis, orderUri, block.timestamp));
        emit SanctionIssued(k, subjectId, kind, basis, orderUri);
    }

    function count(string calldata subjectId) external view returns (uint256) {
        return sanctions[keyFor(subjectId)].length;
    }
}
