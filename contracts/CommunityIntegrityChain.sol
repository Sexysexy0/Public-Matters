// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityIntegrityChain
/// @notice Chain covenant for collective validation of narrative integrity
contract CommunityIntegrityChain {
    address public oversightCommittee;
    uint256 public validationCount;

    struct IntegrityValidation {
        uint256 id;
        string category;     // e.g. business, spiritual, personal
        string contentHash;  // hash of narrative content
        uint256 approvals;
        uint256 rejections;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityValidation) public validations;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ValidationCreated(uint256 indexed id, string category, string contentHash);
    event Voted(uint256 indexed id, address voter, bool approve);
    event ValidationResolved(uint256 indexed id, string category, string contentHash, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates validation record
    function createValidation(string calldata category, string calldata contentHash) external onlyOversight {
        validationCount++;
        validations[validationCount] = IntegrityValidation({
            id: validationCount,
            category: category,
            contentHash: contentHash,
            approvals: 0,
            rejections: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ValidationCreated(validationCount, category, contentHash);
    }

    /// @notice Citizens vote on validation
    function vote(uint256 id, bool approve) external {
        require(!voted[msg.sender][id], "Already voted");
        require(!validations[id].resolved, "Validation resolved");

        voted[msg.sender][id] = true;
        if (approve) {
            validations[id].approvals++;
        } else {
            validations[id].rejections++;
        }
        emit Voted(id, msg.sender, approve);
    }

    /// @notice Oversight resolves validation
    function resolveValidation(uint256 id) external onlyOversight {
        IntegrityValidation storage v = validations[id];
        require(!v.resolved, "Already resolved");
        v.resolved = true;
        bool passed = v.approvals > v.rejections;
        emit ValidationResolved(id, v.category, v.contentHash, passed);
    }
}
