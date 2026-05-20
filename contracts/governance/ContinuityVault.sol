// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * ContinuityVault
 * Vault safeguard para sa archival ng governance proofs at audit trails.
 * - Owner: highest authority (Vinvin)
 * - Functions: store proofs, retrieve, lock, and seal archives
 */
contract ContinuityVault {
    address public owner;

    struct Archive {
        uint256 id;
        string title;
        string description;
        string hashProof; // keccak256 hash ng audit file / governance doc
        uint256 timestamp;
        bool sealed;
    }

    uint256 public nextArchiveId;
    mapping(uint256 => Archive) public archives;

    event ArchiveStored(uint256 indexed id, string title, string hashProof);
    event ArchiveSealed(uint256 indexed id, address indexed sealer);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Store new governance proof
    function storeArchive(
        string calldata title,
        string calldata description,
        string calldata hashProof
    ) external onlyOwner {
        archives[nextArchiveId] = Archive({
            id: nextArchiveId,
            title: title,
            description: description,
            hashProof: hashProof,
            timestamp: block.timestamp,
            sealed: false
        });
        emit ArchiveStored(nextArchiveId, title, hashProof);
        nextArchiveId++;
    }

    // Seal archive (immutable)
    function sealArchive(uint256 id) external onlyOwner {
        require(!archives[id].sealed, "Already sealed");
        archives[id].sealed = true;
        emit ArchiveSealed(id, msg.sender);
    }

    // Retrieve archive details
    function getArchive(uint256 id) external view returns (Archive memory) {
        return archives[id];
    }
}
