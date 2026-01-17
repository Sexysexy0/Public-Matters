pragma solidity ^0.8.20;

contract AdaptabilityGrowthProtocol {
    address public admin;

    struct Season {
        string phase;        // e.g. challenge, growth, harvest
        string lesson;       // e.g. adaptability, resilience, continuous learning
        uint256 timestamp;
    }

    Season[] public seasons;

    event SeasonLogged(string phase, string lesson, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSeason(string calldata phase, string calldata lesson) external onlyAdmin {
        seasons.push(Season(phase, lesson, block.timestamp));
        emit SeasonLogged(phase, lesson, block.timestamp);
    }

    function totalSeasons() external view returns (uint256) {
        return seasons.length;
    }
}
