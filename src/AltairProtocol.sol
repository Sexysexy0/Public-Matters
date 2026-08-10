// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AltairProtocol (Brick #26)
 * @dev Enforces strict discipline, code compliance, and Brotherhood registry recovery.
 */
contract AltairProtocol {
    address public masterSteward;
    bool public codexLocked;
    
    mapping(address => bool) public certifiedBrothers;
    mapping(address => uint256) public disciplineIndex;

    event BrotherhoodEnforced(address indexed brother, uint256 index);
    event CodexLockUpdated(bool status);

    modifier onlyMaster() {
        require(msg.sender == masterSteward, "Unauthorized: Only the Master Steward can call this.");
        _;
    }

    constructor() {
        masterSteward = msg.sender;
        codexLocked = false;
    }

    function discipline(address _candidate) external onlyMaster {
        require(!codexLocked, "Codex is locked. No changes allowed.");
        certifiedBrothers[_candidate] = true;
        disciplineIndex[_candidate] += 100;
        emit BrotherhoodEnforced(_candidate, disciplineIndex[_candidate]);
    }

    function lockCodex() external onlyMaster {
        codexLocked = true;
        emit CodexLockUpdated(true);
    }
}
