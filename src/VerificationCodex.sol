// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VerificationCodex {
    string[] private entries;

    function addEntry(string memory proof) public {
        entries.push(proof);
    }

    function getEntry(uint256 index) public view returns (string memory) {
        require(index < entries.length, "Invalid index");
        return entries[index];
    }

    function totalEntries() public view returns (uint256) {
        return entries.length;
    }
}
