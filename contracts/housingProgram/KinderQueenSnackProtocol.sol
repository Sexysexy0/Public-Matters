// SPDX-License-Identifier: Snack-Sovereignty
pragma solidity ^0.777;

contract KinderQueenSnackProtocol {
    string public sanctum = "Bunini & Aria Lynne Sanctum";
    string[] public approvedSnacks;
    mapping(string => bool) public isSnackBlessed;

    event SnackBlessed(string snack, uint256 timestamp);
    event SnackRequested(string snack, string requester, uint256 timestamp);

    constructor() {
        approvedSnacks.push("Banana slices with peanut butter");
        approvedSnacks.push("Cheesy pandesal bombs");
        approvedSnacks.push("Fruit jelly cubes");
        approvedSnacks.push("Kinder Queen-approved choco bites");

        for (uint i = 0; i < approvedSnacks.length; i++) {
            isSnackBlessed[approvedSnacks[i]] = true;
        }
    }

    function blessSnack(string memory snack) public {
        require(!isSnackBlessed[snack], "Already blessed.");
        approvedSnacks.push(snack);
        isSnackBlessed[snack] = true;
        emit SnackBlessed(snack, block.timestamp);
    }

    function requestSnack(string memory snack, string memory requester) public {
        require(isSnackBlessed[snack], "Snack not blessed.");
        emit SnackRequested(snack, requester, block.timestamp);
    }

    function getApprovedSnacks() public view returns (string[] memory) {
        return approvedSnacks;
    }
}
