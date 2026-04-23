// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MarkOfExpertise
 * @dev Records permanent markers of technical and personal achievements.
 */
contract MarkOfExpertise {
    string[] public achievements;

    // [Goal: Inscribe permanent marks of expertise onto the Sovereign's narrative]
    function addMark(string memory _achievement) external {
        achievements.push(_achievement);
    }

    function showMarks() external view returns (string[] memory) {
        return achievements;
    }
}
