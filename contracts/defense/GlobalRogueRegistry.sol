// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title Global Rogue Registry
/// @dev Ritualizes audit visibility, bounty sync, and emotional APR tracking for planetary justice

contract GlobalRogueRegistry {
    address public steward;

    struct RogueProfile {
        string name;
        string originState;
        string violationType;
        uint256 emotionalAPR;
        bool bountyActive;
        bool arrested;
    }

    mapping(address => RogueProfile) public rogueLedger;
    address[] public rogueList;

    event RogueRegistered(address indexed actor, string name, string violationType);
    event BountyActivated(address indexed actor);
    event ArrestLogged(address indexed actor);
    event APRUpdated(address indexed actor, uint256 score);

    modifier onlySteward() {
        require(msg.sender == steward, "Scroll access denied");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerRogue(
        address actor,
        string memory name,
        string memory originState,
        string memory violationType,
        uint256 emotionalAPR
    ) public onlySteward {
        rogueLedger[actor] = RogueProfile(name, originState, violationType, emotionalAPR, false, false);
        rogueList.push(actor);
        emit RogueRegistered(actor, name, violationType);
    }

    function activateBounty(address actor) public onlySteward {
        require(bytes(rogueLedger[actor].name).length > 0, "Actor not registered");
        rogueLedger[actor].bountyActive = true;
        emit BountyActivated(actor);
    }

    function logArrest(address actor) public onlySteward {
        require(rogueLedger[actor].bountyActive, "Bounty not active");
        rogueLedger[actor].arrested = true;
        emit ArrestLogged(actor);
    }

    function updateAPR(address actor, uint256 score) public onlySteward {
        rogueLedger[actor].emotionalAPR = score;
        emit APRUpdated(actor, score);
    }

    function getRogueList() public view returns (address[] memory) {
        return rogueList;
    }

    function getRogueProfile(address actor) public view returns (RogueProfile memory) {
        return rogueLedger[actor];
    }
}
