pragma solidity ^0.8.20;

contract SeasonOfLifeProtocol {
    address public admin;

    struct Season {
        string phase;        // e.g. winter, spring, challenge, harvest
        string lesson;       // e.g. adaptability, growth, resilience
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
