// RequirementValidator.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RequirementValidator is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Requirement {
        string description;
        address owner; // Accountability [1:09]
        bool isQuestioned;
    }

    function addRequirement(string memory _desc, address _owner) public {
        // Step 1: Question it regardless of who gave it to you.
        // Even if the CEO said it, if it's dumb, mark it for review.
    }
}
