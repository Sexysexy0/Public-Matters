// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereignFocus
 * @dev Enforces strict attention allocation to the user's primary life-objectives.
 */
contract SovereignFocus {
    string public immutable endgame;
    uint256 public lastAudit;

    constructor() {
        endgame = "LEGAL_FREEDOM_AND_ENGINEERING_MASTERY";
        lastAudit = block.timestamp;
    }

    // [Goal: Kill any mental process that deviates from the Sovereign's endgame]
    function filterAttention(string memory _activity, bool _isProductive) external returns (string memory) {
        if (!_isProductive) {
            return "TERMINATED: Focus leakage detected. Re-routing energy to Sovereign Main Thread.";
        }
        
        lastAudit = block.timestamp;
        return string(abi.encodePacked("LOCKED: '", _activity, "' is aligned with: ", endgame));
    }

    function getFocusHealth() external view returns (uint256) {
        // Higher value means more recent focus audit.
        return block.timestamp - lastAudit;
    }
}
