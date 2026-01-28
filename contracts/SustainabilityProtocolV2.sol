pragma solidity ^0.8.20;

contract SustainabilityProtocolV2 {
    address public admin;

    struct Sustainability {
        string domain;       // e.g. energy, environment, finance
        string measure;      // e.g. green compute, balanced ROI
        string goal;         // e.g. long-term viability, ecosystem health
        uint256 timestamp;
    }

    Sustainability[] public sustainabilities;

    event SustainabilityLogged(string domain, string measure, string goal, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSustainability(string calldata domain, string calldata measure, string calldata goal) external onlyAdmin {
        sustainabilities.push(Sustainability(domain, measure, goal, block.timestamp));
        emit SustainabilityLogged(domain, measure, goal, block.timestamp);
    }

    function totalSustainabilities() external view returns (uint256) {
        return sustainabilities.length;
    }
}
