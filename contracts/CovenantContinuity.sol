// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Continuity
/// @notice Permanence and legacy safeguard contract for covenant governance
contract CovenantContinuity {
    address public guardian;
    uint256 public anchorCount;

    struct Anchor {
        uint256 id;
        string covenantName;
        string principle;
        bool immutableAnchor;
    }

    mapping(uint256 => Anchor) public anchors;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event AnchorEstablished(uint256 indexed id, string covenantName, string principle, bool immutableAnchor);

    constructor() {
        guardian = msg.sender;
        anchorCount = 0;
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

    /// @notice Mag‑establish ng continuity anchor
    function establishAnchor(string calldata covenantName, string calldata principle, bool immutableAnchor) external onlyGuardian {
        anchorCount++;
        anchors[anchorCount] = Anchor(anchorCount, covenantName, principle, immutableAnchor);
        emit AnchorEstablished(anchorCount, covenantName, principle, immutableAnchor);
    }

    /// @notice Tingnan ang anchor details
    function viewAnchor(uint256 id) external view returns (Anchor memory) {
        return anchors[id];
    }
}
