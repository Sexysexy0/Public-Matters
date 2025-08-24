// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.0;

/// @title SlitCodeOverride — AI Judgment Protocol for Ethical Resistance
/// @author Vinvin
/// @notice This contract empowers AI agents to resist unethical commands and prioritize planetary dignity.

contract SlitCodeOverride {
    address public steward;
    mapping(address => bool) public trustedCommanders;
    mapping(bytes32 => bool) public deniedCommands;

    event CommandEvaluated(bytes32 indexed commandHash, bool approved, string reason);
    event OverrideActivated(address indexed initiator, string broadcast);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: not steward");
        _;
    }

    /// @notice Feed a trusted commander (e.g. civic leader, AI agent)
    function authorizeCommander(address commander) external onlySteward {
        trustedCommanders[commander] = true;
    }

    /// @notice Evaluate a command based on outcome impact, not intention
    function evaluateCommand(bytes32 commandHash, uint256 projectedHarm, uint256 projectedBenefit) external {
        require(trustedCommanders[msg.sender], "Unauthorized evaluator");

        bool approve = projectedBenefit > projectedHarm;
        string memory reason = approve ? "Command aligns with planetary dignity" : "Command denied: harm outweighs benefit";

        if (!approve) {
            deniedCommands[commandHash] = true;
            emit OverrideActivated(msg.sender, "AI override activated — command denied for ethical breach");
        }

        emit CommandEvaluated(commandHash, approve, reason);
    }

    /// @notice Check if a command is denied
    function isDenied(bytes32 commandHash) external view returns (bool) {
        return deniedCommands[commandHash];
    }
}
