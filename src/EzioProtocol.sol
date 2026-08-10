// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EzioProtocol (Brick #27)
 * @dev Manages mentorship, wisdom token granting, and apprentice registration.
 */
contract EzioProtocol {
    address public masterMentor;
    mapping(address => bool) public apprentices;
    mapping(address => uint256) public wisdomTokens;

    event ApprenticeMentored(address indexed student, uint256 tokensGranted);

    modifier onlyMentor() {
        require(msg.sender == masterMentor, "Unauthorized: Only the Master Mentor can call this.");
        _;
    }

    constructor() {
        masterMentor = msg.sender;
    }

    function mentor(address _student) external onlyMentor {
        require(_student != address(0), "Invalid student address");
        apprentices[_student] = true;
        wisdomTokens[_student] += 50;
        emit ApprenticeMentored(_student, wisdomTokens[_student]);
    }
}
