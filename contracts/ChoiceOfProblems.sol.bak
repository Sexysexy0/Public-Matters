// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChoiceOfProblems {
    // [Goal: Focus on Meaningful Challenges]
    function filterProblems(string memory _problemSource) public pure returns (bool) {
        // Logic: Is this problem related to my internal purpose?
        // Action: If 'External Milestone' -> IGNORE. If 'Internal Truth' -> SOLVE.
        return keccak256(abi.encodePacked(_problemSource)) == keccak256(abi.encodePacked("Internal"));
    }
}
