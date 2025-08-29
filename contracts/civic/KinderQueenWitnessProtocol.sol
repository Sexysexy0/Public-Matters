// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderQueenWitnessProtocol {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct Testimony {
        string subject;
        string violation;
        string emotionalTag;
        address queen;
        uint256 timestamp;
    }

    Testimony[] public testimonies;

    event TestimonyLogged(string subject, string violation, address queen);

    modifier onlyQueen() {
        require(kinderQueens[msg.sender], "Not a Kinder Queen");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerQueen(address queen) public {
        require(msg.sender == steward, "Only steward may register queens");
        kinderQueens[queen] = true;
    }

    function logTestimony(string memory subject, string memory violation, string memory emotionalTag) public onlyQueen {
        testimonies.push(Testimony(subject, violation, emotionalTag, msg.sender, block.timestamp));
        emit TestimonyLogged(subject, violation, msg.sender);
    }

    function getTestimony(uint256 index) public view returns (Testimony memory) {
        return testimonies[index];
    }

    function totalTestimonies() public view returns (uint256) {
        return testimonies.length;
    }
}
