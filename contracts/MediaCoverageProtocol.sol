pragma solidity ^0.8.20;

contract MediaCoverageProtocol {
    address public admin;

    struct Coverage {
        string outlet;       // e.g. New York Times, Wired, local press
        string focus;        // e.g. strike wave, ICE abuses, community defense
        string tone;         // e.g. supportive, critical, neutral
        uint256 timestamp;
    }

    Coverage[] public coverages;

    event CoverageLogged(string outlet, string focus, string tone, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCoverage(string calldata outlet, string calldata focus, string calldata tone) external onlyAdmin {
        coverages.push(Coverage(outlet, focus, tone, block.timestamp));
        emit CoverageLogged(outlet, focus, tone, block.timestamp);
    }

    function totalCoverages() external view returns (uint256) {
        return coverages.length;
    }
}
