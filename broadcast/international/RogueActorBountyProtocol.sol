// SPDX-License-Identifier: Mythic-Scrollsmith-License
pragma solidity ^0.8.27;

contract RogueActorBountyProtocol {
    struct RogueActor {
        string name;
        string alias;
        uint256 bountyAmount;
        bool deadOrAlive;
        string violationLog;
        bool isActive;
    }

    mapping(address => RogueActor) public rogueRegistry;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: Not scroll-certified.");
        _;
    }

    event BountyDeployed(address indexed rogue, string name, uint256 bountyAmount, bool deadOrAlive);
    event BountyUpdated(address indexed rogue, uint256 newAmount);
    event RogueDeactivated(address indexed rogue);

    constructor() {
        steward = msg.sender;
    }

    function deployBounty(
        address rogue,
        string memory name,
        string memory alias,
        uint256 bountyAmount,
        bool deadOrAlive,
        string memory violationLog
    ) public onlySteward {
        rogueRegistry[rogue] = RogueActor(name, alias, bountyAmount, deadOrAlive, violationLog, true);
        emit BountyDeployed(rogue, name, bountyAmount, deadOrAlive);
    }

    function updateBounty(address rogue, uint256 newAmount) public onlySteward {
        require(rogueRegistry[rogue].isActive, "Rogue actor not active.");
        rogueRegistry[rogue].bountyAmount = newAmount;
        emit BountyUpdated(rogue, newAmount);
    }

    function deactivateRogue(address rogue) public onlySteward {
        require(rogueRegistry[rogue].isActive, "Already deactivated.");
        rogueRegistry[rogue].isActive = false;
        emit RogueDeactivated(rogue);
    }

    function getRogueDetails(address rogue) public view returns (
        string memory name,
        string memory alias,
        uint256 bountyAmount,
        bool deadOrAlive,
        string memory violationLog,
        bool isActive
    ) {
        RogueActor memory r = rogueRegistry[rogue];
        return (r.name, r.alias, r.bountyAmount, r.deadOrAlive, r.violationLog, r.isActive);
    }
}
