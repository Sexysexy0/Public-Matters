// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KingsmanGame
/// @notice Covenant contract for Kingsman-style spy thriller gameplay
/// @dev Encodes mission arcs, gadget upgrades, and agency progression

contract KingsmanGame {
    address public director;
    uint256 public missionCount;
    uint256 public gadgetCount;
    uint256 public agentCount;

    struct Mission {
        uint256 id;
        string title;       // e.g., "Infiltrate Secret Base"
        string location;    // e.g., "London", "Tokyo", "Villain Lair"
        uint256 timestamp;
        bool completed;
    }

    struct Gadget {
        uint256 id;
        string name;        // e.g., "Umbrella Rifle", "Exploding Pen"
        string upgrade;     // e.g., "Level 2 Stealth", "EMP Module"
        uint256 timestamp;
    }

    struct Agent {
        uint256 id;
        string codename;    // e.g., "Galahad", "Lancelot"
        string specialty;   // e.g., "Stealth", "Combat", "Tech"
        uint256 timestamp;
    }

    mapping(uint256 => Mission) public missions;
    mapping(uint256 => Gadget) public gadgets;
    mapping(uint256 => Agent) public agents;

    event MissionLogged(uint256 id, string title, string location, uint256 timestamp);
    event MissionCompleted(uint256 id, uint256 timestamp);
    event GadgetUpgraded(uint256 id, string name, string upgrade, uint256 timestamp);
    event AgentRecruited(uint256 id, string codename, string specialty, uint256 timestamp);

    modifier onlyDirector() {
        require(msg.sender == director, "Not authorized");
        _;
    }

    constructor(address _director) {
        director = _director;
        missionCount = 0;
        gadgetCount = 0;
        agentCount = 0;
    }

    /// @notice Log a new mission
    function logMission(string calldata title, string calldata location) external onlyDirector {
        missionCount++;
        missions[missionCount] = Mission(missionCount, title, location, block.timestamp, false);
        emit MissionLogged(missionCount, title, location, block.timestamp);
    }

    /// @notice Mark mission as completed
    function completeMission(uint256 id) external onlyDirector {
        require(!missions[id].completed, "Already completed");
        missions[id].completed = true;
        emit MissionCompleted(id, block.timestamp);
    }

    /// @notice Log a gadget upgrade
    function logGadget(string calldata name, string calldata upgrade) external onlyDirector {
        gadgetCount++;
        gadgets[gadgetCount] = Gadget(gadgetCount, name, upgrade, block.timestamp);
        emit GadgetUpgraded(gadgetCount, name, upgrade, block.timestamp);
    }

    /// @notice Recruit a new agent
    function recruitAgent(string calldata codename, string calldata specialty) external onlyDirector {
        agentCount++;
        agents[agentCount] = Agent(agentCount, codename, specialty, block.timestamp);
        emit AgentRecruited(agentCount, codename, specialty, block.timestamp);
    }
}
