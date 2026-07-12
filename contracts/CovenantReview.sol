// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Review
/// @notice Periodic evaluation contract for covenant governance system
contract CovenantReview {
    address public guardian;
    uint256 public reviewCount;

    struct Review {
        uint256 id;
        string subject;
        string findings;
        string recommendations;
        bool published;
    }

    mapping(uint256 => Review) public reviews;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ReviewCreated(uint256 indexed id, string subject);
    event ReviewPublished(uint256 indexed id, string findings, string recommendations);

    constructor() {
        guardian = msg.sender;
        reviewCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Gumawa ng bagong review draft
    function createReview(string calldata subject) external onlyGuardian {
        reviewCount++;
        reviews[reviewCount] = Review(reviewCount, subject, "", "", false);
        emit ReviewCreated(reviewCount, subject);
    }

    /// @notice Mag‑publish ng findings at recommendations
    function publishReview(uint256 id, string calldata findings, string calldata recommendations) external onlyGuardian {
        Review storage r = reviews[id];
        require(!r.published, "Already published");
        r.findings = findings;
        r.recommendations = recommendations;
        r.published = true;
        emit ReviewPublished(id, findings, recommendations);
    }

    /// @notice Tingnan ang review details
    function viewReview(uint256 id) external view returns (Review memory) {
        return reviews[id];
    }
}
