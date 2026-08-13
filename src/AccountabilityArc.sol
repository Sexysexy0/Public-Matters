// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccountabilityArc {
    string[] private actions;

    function logAction(string memory action) public {
        actions.push(action);
    }

    function getAction(uint256 index) public view returns (string memory) {
        require(index < actions.length, "Invalid index");
        return actions[index];
    }

    function totalActions() public view returns (uint256) {
        return actions.length;
    }
}
