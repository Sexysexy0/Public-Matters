pragma solidity ^0.8.20;

contract AIDisruptionProtocol {
    address public admin;

    struct Disruption {
        string skill;        // e.g. Email writing, Coding
        string status;       // e.g. Automated, Threatened
        uint256 timestamp;
    }

    Disruption[] public disruptions;

    event DisruptionLogged(string skill, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDisruption(string calldata skill, string calldata status) external onlyAdmin {
        disruptions.push(Disruption(skill, status, block.timestamp));
        emit DisruptionLogged(skill, status, block.timestamp);
    }

    function totalDisruptions() external view returns (uint256) {
        return disruptions.length;
    }
}
