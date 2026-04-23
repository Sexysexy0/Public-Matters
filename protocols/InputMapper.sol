// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InputMapper {
    mapping(string => string) public customBindings;

    // [Goal: Allow the Sovereign to re-map any life-action to a specific trigger]
    function setBinding(string memory _trigger, string memory _action) external {
        customBindings[_trigger] = _action;
    }

    function executeAction(string memory _trigger) external view returns (string memory) {
        return string(abi.encodePacked("EXECUTING: ", customBindings[_trigger]));
    }
}
