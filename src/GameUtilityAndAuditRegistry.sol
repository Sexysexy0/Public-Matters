// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GameUtilityAndAuditRegistry
 * @dev Tracks internal utility usage (balance tests, simulations) and validates human-craft attestations.
 */
contract GameUtilityAndAuditRegistry {
    enum UtilityType {
        BalanceSimulation,
        ProceduralWorldSeed,
        BackendAutomatedReporting,
        CodeOptimization
    }

    struct UtilityRecord {
        bytes32 recordId;
        UtilityType utilType;
        bytes32 proofHash; // IPFS / Commit hash of test logs or logic seeds
        uint256 timestamp;
        address reporter;
    }

    struct HumanCraftAttestation {
        bytes32 assetId;
        string assetCategory; // e.g., "Main Narrative", "Character Art", "Audio Score"
        bytes32 creatorSignatureHash;
        bool isHumanVerified;
        uint256 timestamp;
    }

    address public owner;
    mapping(bytes32 => UtilityRecord) public utilityRecords;
    mapping(bytes32 => HumanCraftAttestation) public craftAttestations;

    event InternalUtilityLogged(bytes32 indexed recordId, UtilityType utilType, bytes32 proofHash);
    event HumanCraftAttested(bytes32 indexed assetId, string assetCategory, address indexed verifier);

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: Owner only");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Log internal AI/Automated utility (e.g., economy balancing, procedural seeds).
     */
    function logInternalUtility(bytes32 _rawInput, UtilityType _utilType, bytes32 _proofHash)
        external
        returns (bytes32)
    {
        bytes32 recordId = keccak256(abi.encodePacked(_rawInput, msg.sender, block.timestamp));

        utilityRecords[recordId] = UtilityRecord({
            recordId: recordId,
            utilType: _utilType,
            proofHash: _proofHash,
            timestamp: block.timestamp,
            reporter: msg.sender
        });

        emit InternalUtilityLogged(recordId, _utilType, _proofHash);
        return recordId;
    }

    /**
     * @notice Attest that key game assets (Art, Music, Lore) are human-crafted to protect store review score.
     */
    function attestHumanCraft(bytes32 _assetId, string calldata _category, bytes32 _sigHash) external onlyOwner {
        craftAttestations[_assetId] = HumanCraftAttestation({
            assetId: _assetId,
            assetCategory: _category,
            creatorSignatureHash: _sigHash,
            isHumanVerified: true,
            timestamp: block.timestamp
        });

        emit HumanCraftAttested(_assetId, _category, msg.sender);
    }
}
