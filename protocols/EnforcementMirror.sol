// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Enforcement Mirror Arc: record selective enforcement actions
contract EnforcementMirror {
    struct Action {
        uint256 id;
        string caseName;
        string actionTaken;
        address actor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Action) public actions;
    mapping(address => bool) public validators;
    address public steward;

    event ActionLogged(uint256 indexed id, string caseName, string actionTaken);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
    }

    function logAction(string calldata _caseName, string calldata _actionTaken) external {
        require(validators[msg.sender], "Not validator");
        actions[nextId] = Action(nextId, _caseName, _actionTaken, msg.sender, block.timestamp);
        emit ActionLogged(nextId, _caseName, _actionTaken);
        nextId++;
    }
}
