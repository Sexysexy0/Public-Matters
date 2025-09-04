// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title APROracle
/// @dev Calculates emotional APR based on steward feedback and onboarding rituals.

contract APROracle {
    address public stewardCouncil;
    mapping(address => uint256) public aprScores;
    mapping(address => string[]) public feedbackScrolls;

    event APRUpdated(address indexed steward, uint256 newScore);
    event FeedbackLogged(address indexed steward, string scroll);

    modifier onlyCouncil() {
        require(msg.sender == stewardCouncil, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        stewardCouncil = msg.sender;
    }

    function updateAPR(address _steward, uint256 _score) external onlyCouncil {
        require(_score <= 100, "APR must be ≤ 100");
        aprScores[_steward] = _score;
        emit APRUpdated(_steward, _score);
    }

    function logFeedback(address _steward, string memory _scroll) external onlyCouncil {
        feedbackScrolls[_steward].push(_scroll);
        emit FeedbackLogged(_steward, _scroll);
    }

    function getAPR(address _steward) external view returns (uint256) {
        return aprScores[_steward];
    }

    function getFeedback(address _steward) external view returns (string[] memory) {
        return feedbackScrolls[_steward];
    }
}
