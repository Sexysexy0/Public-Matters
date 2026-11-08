// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AuthenticityOracle
 * @notice Immutable proof of creation (prior art) for game builds, code, or art.
 *         Any creator can register a hash. First to register wins the timestamp.
 */
contract AuthenticityOracle {
    OperatorPrivileges public immutable privileges;

    struct Work {
        address creator;
        bytes32 metadataHash; // IPFS hash or metadata
        uint256 timestamp;
        bool verified;        // Operator verified (e.g., audited or physically verified)
    }

    mapping(bytes32 => Work) public works;

    event WorkRegistered(bytes32 indexed contentHash, address indexed creator, bytes32 metadataHash);
    event WorkVerified(bytes32 indexed contentHash, address indexed verifier);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice Register a cryptographic hash of your original work.
     * @param contentHash The keccak256 hash of the game build/file.
     * @param metadataHash The IPFS hash of the metadata/description.
     */
    function registerWork(bytes32 contentHash, bytes32 metadataHash) external {
        require(contentHash != bytes32(0), "contentHash=0");
        require(works[contentHash].creator == address(0), "Work already registered");

        works[contentHash] = Work({
            creator: msg.sender,
            metadataHash: metadataHash,
            timestamp: block.timestamp,
            verified: false
        });

        emit WorkRegistered(contentHash, msg.sender, metadataHash);
    }

    /**
     * @notice Operator verifies a registered work (adds a badge of trust).
     */
    function verifyWork(bytes32 contentHash) external onlyOperator {
        require(works[contentHash].creator != address(0), "Work not found");
        works[contentHash].verified = true;
        emit WorkVerified(contentHash, msg.sender);
    }

    function getWork(bytes32 contentHash) external view returns (Work memory) {
        return works[contentHash];
    }
}
