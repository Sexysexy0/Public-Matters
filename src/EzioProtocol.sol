// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EzioProtocol
 * @dev Mentor archetype: trains apprentices, grants wisdom tokens.
 */
contract EzioProtocol {
    address public mentor;
    mapping(address => bool) public apprentices;

    event ApprenticeMentored(address indexed apprentice);
    event WisdomGranted(address indexed apprentice);

    modifier onlyMentor() {
        require(msg.sender == mentor, "Only mentor");
        _;
    }

    constructor() {
        mentor = msg.sender;
    }

    function mentorApprentice(address _apprentice) external onlyMentor {
        apprentices[_apprentice] = true;
        emit ApprenticeMentored(_apprentice);
    }

    function grantWisdom(address _apprentice) external onlyMentor {
        require(apprentices[_apprentice], "Not an apprentice");
        emit WisdomGranted(_apprentice);
    }
}
