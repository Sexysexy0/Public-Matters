pragma solidity ^0.8.20;

contract SkillHubProtocol {
    address public admin;

    struct SkillHub {
        string skill;        // e.g. coding, design, trades
        string provider;     // e.g. NGO, government, private sector
        string benefit;      // e.g. employability, entrepreneurship
        uint256 timestamp;
    }

    SkillHub[] public hubs;

    event SkillHubLogged(string skill, string provider, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSkillHub(string calldata skill, string calldata provider, string calldata benefit) external onlyAdmin {
        hubs.push(SkillHub(skill, provider, benefit, block.timestamp));
        emit SkillHubLogged(skill, provider, benefit, block.timestamp);
    }

    function totalSkillHubs() external view returns (uint256) {
        return hubs.length;
    }
}
