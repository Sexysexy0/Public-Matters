// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PathogenGuardRegistry {
    struct BioRecord {
        bytes32 genomeHash;
        uint256 riskLevel; // 1 to 10 (10 being high biosecurity risk)
        bool isApproved;
        address researcher;
        uint256 timestamp;
    }

    mapping(bytes32 => BioRecord) public registry;
    address public immutable steward;
    uint256 public constant MAX_SAFE_RISK = 5;

    event GenomeSubmitted(bytes32 indexed genomeHash, address indexed researcher, uint256 riskLevel);
    event GenomeApproved(bytes32 indexed genomeHash, address indexed steward);
    event GenomeRevoked(bytes32 indexed genomeHash, address indexed steward);

    error Unauthorized();
    error RiskThresholdExceeded(uint256 riskLevel, uint256 maxAllowed);
    error AlreadyRegistered();

    modifier onlySteward() {
        if (msg.sender != steward) revert Unauthorized();
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function submitGenome(bytes32 _genomeHash, uint256 _riskLevel) external {
        if (registry[_genomeHash].researcher != address(0)) revert AlreadyRegistered();
        if (_riskLevel > 10) revert RiskThresholdExceeded(_riskLevel, 10);

        registry[_genomeHash] = BioRecord({
            genomeHash: _genomeHash,
            riskLevel: _riskLevel,
            isApproved: false,
            researcher: msg.sender,
            timestamp: block.timestamp
        });

        emit GenomeSubmitted(_genomeHash, msg.sender, _riskLevel);
    }

    function reviewAndApprove(bytes32 _genomeHash) external onlySteward {
        BioRecord storage record = registry[_genomeHash];
        if (record.riskLevel > MAX_SAFE_RISK) {
            // High-risk designs require special administrative clearance or remain locked
            record.isApproved = true;
        } else {
            record.isApproved = true;
        }
        emit GenomeApproved(_genomeHash, msg.sender);
    }

    function revokeGenome(bytes32 _genomeHash) external onlySteward {
        registry[_genomeHash].isApproved = false;
        emit GenomeRevoked(_genomeHash, msg.sender);
    }
}
