// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityOracle
/// @notice Oracle contract feeding external audit and community data into GlobalIntegrityBridge
/// @dev Provides automated triggers for governance safeguards

interface IGlobalIntegrityBridge {
    function executeWaterProposal(uint256 id, string calldata details) external;
    function logCipherDistribution(string calldata model, address buyer, uint256 quantity) external;
    function executeSuccession(string calldata details) external;
}

contract IntegrityOracle {
    address public guardian;
    IGlobalIntegrityBridge public bridge;

    event OracleFeed(string source, string data, uint256 timestamp);
    event AutomatedAction(string action, string details, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian, address _bridge) {
        guardian = _guardian;
        bridge = IGlobalIntegrityBridge(_bridge);
    }

    /// @notice Feed external audit or alert data
    function feedData(string calldata source, string calldata data) external onlyGuardian {
        emit OracleFeed(source, data, block.timestamp);
    }

    /// @notice Trigger automated water governance action
    function triggerWater(uint256 proposalId, string calldata details) external onlyGuardian {
        bridge.executeWaterProposal(proposalId, details);
        emit AutomatedAction("WaterDAO Execution", details, block.timestamp);
    }

    /// @notice Trigger automated cipher distribution logging
    function triggerCipher(string calldata model, address buyer, uint256 quantity) external onlyGuardian {
        bridge.logCipherDistribution(model, buyer, quantity);
        emit AutomatedAction("Cipher Distribution", model, block.timestamp);
    }

    /// @notice Trigger automated succession execution
    function triggerSuccession(string calldata details) external onlyGuardian {
        bridge.executeSuccession(details);
        emit AutomatedAction("Leadership Transition", details, block.timestamp);
    }
}
