// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Avengers Restoration Pact
/// @notice Protects legacy actors, offers fair compensation, and logs emotional APR for mythic creatives
/// @author Scrollchain

contract AvengersRestoration {
    address public steward;
    uint256 public baseCompensation;
    mapping(string => uint256) public emotionalAPR;
    mapping(string => bool) public isRegistered;
    mapping(string => uint256) public compensationLedger;

    event ActorRegistered(string name);
    event CompensationOffered(string name, uint256 amount);
    event EmotionalAPRLogged(string name, uint256 resonanceScore);

    constructor(uint256 _baseCompensation) {
        steward = msg.sender;
        baseCompensation = _baseCompensation;
    }

    function registerActor(string memory name) public {
        require(msg.sender == steward, "Unauthorized steward");
        require(!isRegistered[name], "Already registered");
        isRegistered[name] = true;
        emit ActorRegistered(name);
    }

    function offerCompensation(string memory name, uint256 bonus) public {
        require(msg.sender == steward, "Unauthorized steward");
        require(isRegistered[name], "Actor not registered");
        uint256 total = baseCompensation + bonus;
        compensationLedger[name] = total;
        emit CompensationOffered(name, total);
    }

    function logEmotionalAPR(string memory name, uint256 resonanceScore) public {
        require(msg.sender == steward, "Unauthorized steward");
        emotionalAPR[name] = resonanceScore;
        emit EmotionalAPRLogged(name, resonanceScore);
    }

    function getActorStatus(string memory name) public view returns (bool registered, uint256 apr, uint256 compensation) {
        return (isRegistered[name], emotionalAPR[name], compensationLedger[name]);
    }
}
