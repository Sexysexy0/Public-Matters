// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HumanDignity
/// @notice Covenant contract to affirm human uniqueness and dignity in the age of AI
contract HumanDignity {
    address public owner;

    struct Affirmation {
        string principle;    // e.g. "Consciousness", "Moral Agency", "Image of God"
        string safeguard;    // covenant safeguard description
        uint256 timestamp;
    }

    Affirmation[] public affirmations;

    event AffirmationLogged(string principle, string safeguard, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logAffirmation(string memory principle, string memory safeguard) public onlyOwner {
        Affirmation memory newAffirmation = Affirmation(principle, safeguard, block.timestamp);
        affirmations.push(newAffirmation);
        emit AffirmationLogged(principle, safeguard, block.timestamp);
    }

    function getAffirmation(uint256 index) public view returns (string memory, string memory, uint256) {
        Affirmation memory a = affirmations[index];
        return (a.principle, a.safeguard, a.timestamp);
    }

    function getAffirmationCount() public view returns (uint256) {
        return affirmations.length;
    }
}
