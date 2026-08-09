// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CyberOperationalResilience
 * @dev Tactical management for cybersecurity forces and infrastructure modernization.
 * Bridging the gap between Hegseth's directives and the Kingdom's Tech Stack.
 */
contract CyberOperationalResilience {
    address public immutable owner;

    struct CyberUnit {
        address unitCommander;
        string codename;
        uint8 meritScore; // 1 to 100 (Talent Management / Merit-based)
        uint8 adaptabilityIndex; // 1 to 100 (Ability to adapt to new threats)
        bool isActive;
    }

    mapping(address => CyberUnit) public cyberForces;
    address[] public activeCommanders;

    string public currentMissionPriority; // "CyberCom 2.0 Directive"
    bool public systemAlert; // Emergency pause

    event UnitRegistered(address indexed commander, string codename);
    event MeritScoreUpdated(address indexed commander, uint8 newScore);
    event MissionUpdated(string newMission);
    event AlertRaised(bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Top Operator");
        _;
    }

    modifier onlyActiveUnit() {
        require(cyberForces[msg.sender].isActive, "Unit is inactive");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Magrehistro ng bagong cyber unit / operator
    function registerCyberUnit(address _commander, string memory _codename, uint8 _initialMerit) external onlyOwner {
        require(!cyberForces[_commander].isActive, "Unit already registered");
        cyberForces[_commander] = CyberUnit({
            unitCommander: _commander,
            codename: _codename,
            meritScore: _initialMerit,
            adaptabilityIndex: 50, // default
            isActive: true
        });
        activeCommanders.push(_commander);
        emit UnitRegistered(_commander, _codename);
    }

    // Talent Management: I-update ang merit score base sa performance
    function updateMeritScore(address _commander, uint8 _newScore) external onlyOwner {
        require(cyberForces[_commander].isActive, "Unit not found");
        cyberForces[_commander].meritScore = _newScore;
        emit MeritScoreUpdated(_commander, _newScore);
    }

    // Bureaucracy Reduction: Pause or Unpause the entire ecosystem in times of crisis
    function setAlert(bool _status) external onlyOwner {
        systemAlert = _status;
        emit AlertRaised(_status);
    }

    // Adaptability: Change the operational priority based on Hegseth's directives
    function setMissionPriority(string memory _newMission) external onlyOwner {
        currentMissionPriority = _newMission;
        emit MissionUpdated(_newMission);
    }
}
