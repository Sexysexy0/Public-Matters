// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DefenseBridge
/// @notice Connects PromptInjectionDefense with IntegrityOracle and GlobalIntegrityBridge
/// @dev Ensures flagged prompts are logged and propagated across governance layers

interface IPromptInjectionDefense {
    function flagPrompt(string calldata reason) external;
    function clearPrompt(uint256 id) external;
    function isFlagged(uint256 id) external view returns (bool);
}

interface IIntegrityOracle {
    function feedData(string calldata source, string calldata data) external;
}

interface IGlobalIntegrityBridge {
    function executeWaterProposal(uint256 id, string calldata details) external;
    function logCipherDistribution(string calldata model, address buyer, uint256 quantity) external;
    function executeSuccession(string calldata details) external;
}

contract DefenseBridge {
    address public guardian;
    IPromptInjectionDefense public defense;
    IIntegrityOracle public oracle;
    IGlobalIntegrityBridge public bridge;

    event DefenseSynced(string reason, uint256 timestamp);
    event DefenseCleared(uint256 id, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian, address _defense, address _oracle, address _bridge) {
        guardian = _guardian;
        defense = IPromptInjectionDefense(_defense);
        oracle = IIntegrityOracle(_oracle);
        bridge = IGlobalIntegrityBridge(_bridge);
    }

    /// @notice Flag a prompt and sync to oracle + bridge
    function syncFlag(string calldata reason) external onlyGuardian {
        defense.flagPrompt(reason);
        oracle.feedData("PromptInjectionDefense", reason);
        bridge.executeSuccession(reason); // Example: log as governance event
        emit DefenseSynced(reason, block.timestamp);
    }

    /// @notice Clear a flagged prompt and log
    function syncClear(uint256 id, string calldata details) external onlyGuardian {
        defense.clearPrompt(id);
        oracle.feedData("PromptInjectionDefense", details);
        emit DefenseCleared(id, block.timestamp);
    }

    /// @notice Check if a prompt is flagged
    function checkFlag(uint256 id) external view returns (bool) {
        return defense.isFlagged(id);
    }
}
