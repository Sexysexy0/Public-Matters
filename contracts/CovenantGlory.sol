// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Glory
/// @notice Exaltation and triumph safeguard contract
contract CovenantGlory {
    address public guardian;
    uint256 public gloryCount;

    struct Triumph {
        uint256 id;
        string subject;
        string exaltationPrinciple;
        string celebrationPath;
        bool achieved;
    }

    mapping(uint256 => Triumph) public triumphs;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event GloryDeclared(uint256 indexed id, string subject, string exaltationPrinciple);
    event GloryAchieved(uint256 indexed id, string celebrationPath);

    constructor() {
        guardian = msg.sender;
        gloryCount = 0;
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

    /// @notice Mag‑declare ng glory principle
    function declareGlory(string calldata subject, string calldata exaltationPrinciple) external onlyGuardian {
        gloryCount++;
        triumphs[gloryCount] = Triumph(gloryCount, subject, exaltationPrinciple, "", false);
        emit GloryDeclared(gloryCount, subject, exaltationPrinciple);
    }

    /// @notice Mag‑achieve ng glory at mag‑assign ng celebration path
    function achieveGlory(uint256 id, string calldata celebrationPath) external onlyGuardian {
        Triumph storage t = triumphs[id];
        require(!t.achieved, "Already achieved");
        t.celebrationPath = celebrationPath;
        t.achieved = true;
        emit GloryAchieved(id, celebrationPath);
    }

    /// @notice Tingnan ang glory details
    function viewGlory(uint256 id) external view returns (Triumph memory) {
        return triumphs[id];
    }
}
