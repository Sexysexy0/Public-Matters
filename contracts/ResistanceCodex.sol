// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResistanceCodex
/// @notice Covenant contract encoding safeguards against systemic abuses
contract ResistanceCodex {
    address public guardian;
    uint256 public transparencyThreshold;

    struct AbuseArc {
        string category;       // e.g. "Debt", "War", "Media", "Tech"
        string description;    // details of the abuse
        uint256 timestamp;
        bool remedied;
    }

    AbuseArc[] public abuses;

    event AbuseRecorded(string category, string description, uint256 timestamp, bool remedied);
    event TransparencyUpdated(uint256 newThreshold, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(uint256 _transparencyThreshold) {
        guardian = msg.sender;
        transparencyThreshold = _transparencyThreshold;
    }

    /// @notice Update transparency threshold (minimum openness required)
    function updateTransparency(uint256 _newThreshold) public onlyGuardian {
        transparencyThreshold = _newThreshold;
        emit TransparencyUpdated(_newThreshold, block.timestamp);
    }

    /// @notice Record a systemic abuse and its remedy status
    function recordAbuse(
        string memory category,
        string memory description,
        bool remedied
    ) public onlyGuardian {
        AbuseArc memory arc = AbuseArc(category, description, block.timestamp, remedied);
        abuses.push(arc);
        emit AbuseRecorded(category, description, block.timestamp, remedied);
    }

    /// @notice Retrieve an abuse arc by index
    function getAbuse(uint256 index)
        public
        view
        returns (string memory, string memory, uint256, bool)
    {
        AbuseArc memory arc = abuses[index];
        return (arc.category, arc.description, arc.timestamp, arc.remedied);
    }

    /// @notice Get total number of abuses recorded
    function getAbuseCount() public view returns (uint256) {
        return abuses.length;
    }
}
