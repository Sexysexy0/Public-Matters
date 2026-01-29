pragma solidity ^0.8.20;

contract TradesmanKingProtocol {
    address public admin;

    struct Crown {
        string skill;        // e.g. Welding, HVAC repair
        string recognition;  // e.g. "Civilization Guardian"
        uint256 timestamp;
    }

    Crown[] public crowns;

    event CrownLogged(string skill, string recognition, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCrown(string calldata skill, string calldata recognition) external onlyAdmin {
        crowns.push(Crown(skill, recognition, block.timestamp));
        emit CrownLogged(skill, recognition, block.timestamp);
    }

    function totalCrowns() external view returns (uint256) {
        return crowns.length;
    }
}
