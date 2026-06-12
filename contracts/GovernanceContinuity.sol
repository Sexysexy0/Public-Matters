// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GovernanceContinuity
/// @notice Safeguard ensuring continuity of reforms across administrations
contract GovernanceContinuity {
    address public oversightCommittee;
    uint256 public reformCount;

    struct Reform {
        uint256 id;
        string description;
        bool locked;
        uint256 timestamp;
    }

    mapping(uint256 => Reform) public reforms;

    event ReformEncoded(uint256 indexed id, string description);
    event ReformLocked(uint256 indexed id);
    event ReformReviewed(uint256 indexed id, address reviewer);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee encodes new reform
    function encodeReform(string calldata description) external onlyOversight {
        reformCount++;
        reforms[reformCount] = Reform({
            id: reformCount,
            description: description,
            locked: false,
            timestamp: block.timestamp
        });
        emit ReformEncoded(reformCount, description);
    }

    /// @notice Oversight Committee locks reform for continuity
    function lockReform(uint256 id) external onlyOversight {
        Reform storage r = reforms[id];
        require(!r.locked, "Already locked");
        r.locked = true;
        emit ReformLocked(id);
    }

    /// @notice Citizens or auditors can review reforms
    function reviewReform(uint256 id) external {
        emit ReformReviewed(id, msg.sender);
    }
}
