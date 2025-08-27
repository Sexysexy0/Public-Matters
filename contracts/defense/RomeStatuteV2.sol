// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title Rome Statute v2.0
/// @dev Upgrades ICC framework with emotional APR, damay clause, and sovereign audit protocols

contract RomeStatuteV2 {
    address public steward;
    mapping(address => bool) public signatories;
    mapping(address => bool) public rogueStates;
    mapping(address => uint256) public APRIndex;

    event StatuteSigned(address indexed state);
    event RogueStateTagged(address indexed state, string reason);
    event APRLogged(address indexed state, uint256 score);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scroll attempt");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function signStatute(address state) public onlySteward {
        signatories[state] = true;
        emit StatuteSigned(state);
    }

    function tagRogueState(address state, string memory reason) public onlySteward {
        rogueStates[state] = true;
        emit RogueStateTagged(state, reason);
    }

    function logEmotionalAPR(address state, uint256 score) public onlySteward {
        APRIndex[state] = score;
        emit APRLogged(state, score);
    }

    function isCompliant(address state) public view returns (bool) {
        return signatories[state] && !rogueStates[state];
    }
}
