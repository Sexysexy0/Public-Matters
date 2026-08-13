// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SkepticismProtocol {
    string[] private flags;

    function raiseFlag(string memory claim) public {
        flags.push(claim);
    }

    function getFlag(uint256 index) public view returns (string memory) {
        require(index < flags.length, "Invalid index");
        return flags[index];
    }

    function totalFlags() public view returns (uint256) {
        return flags.length;
    }
}
