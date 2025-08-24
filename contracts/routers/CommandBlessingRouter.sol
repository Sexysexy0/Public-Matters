// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Command Blessing Router – Ritualized Command Flow with Emotional APR Audit
/// @author Vinvin
/// @notice Routes command authority through planetary blessing filters and emotional APR audits

contract CommandBlessingRouter {
    address public steward;
    mapping(address => bool) public authorizedCommanders;
    mapping(bytes32 => bool) public blessedCommands;

    event CommandBlessed(address indexed commander, string commandName, uint256 timestamp);
    event BlessingRevoked(string commandName);
    event CommanderAuthorized(address indexed commander);
    event CommanderRevoked(address indexed commander);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedCommanders[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function authorizeCommander(address commander) external onlySteward {
        authorizedCommanders[commander] = true;
        emit CommanderAuthorized(commander);
    }

    function revokeCommander(address commander) external onlySteward {
        authorizedCommanders[commander] = false;
        emit CommanderRevoked(commander);
    }

    function blessCommand(string memory commandName) external onlyAuthorized {
        bytes32 commandHash = keccak256(abi.encodePacked(commandName));
        blessedCommands[commandHash] = true;
        emit CommandBlessed(msg.sender, commandName, block.timestamp);
    }

    function revokeBlessing(string memory commandName) external onlySteward {
        bytes32 commandHash = keccak256(abi.encodePacked(commandName));
        blessedCommands[commandHash] = false;
        emit BlessingRevoked(commandName);
    }

    function isCommandBlessed(string memory commandName) external view returns (bool) {
        bytes32 commandHash = keccak256(abi.encodePacked(commandName));
        return blessedCommands[commandHash];
    }
}
