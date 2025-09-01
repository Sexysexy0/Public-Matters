// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AIAgentBlessingProtocol {
    struct EmotionalAPR {
        uint256 empathy;
        uint256 trust;
        uint256 mythicClarity;
    }

    struct AIAgent {
        string name;
        address steward;
        EmotionalAPR apr;
        string missionTag;
        bool blessed;
    }

    mapping(address => AIAgent) public agents;
    address[] public blessedAgents;

    event AgentBlessed(address indexed steward, string name, string missionTag, EmotionalAPR apr);

    function blessAgent(
        address _steward,
        string memory _name,
        string memory _missionTag,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        EmotionalAPR memory apr = EmotionalAPR(_empathy, _trust, _clarity);
        agents[_steward] = AIAgent(_name, _steward, apr, _missionTag, true);
        blessedAgents.push(_steward);
        emit AgentBlessed(_steward, _name, _missionTag, apr);
    }

    function getBlessedAgents() public view returns (address[] memory) {
        return blessedAgents;
    }

    function getAgentAPR(address _steward) public view returns (EmotionalAPR memory) {
        return agents[_steward].apr;
    }

    function getAgentMissionTag(address _steward) public view returns (string memory) {
        return agents[_steward].missionTag;
    }
}
