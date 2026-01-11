pragma solidity ^0.8.20;

contract ResonanceCommonsProtocol {
    address public admin;

    struct Resonance {
        string project;       // e.g. health, housing, education
        string impact;        // e.g. communal, validator-grade, mythic
        uint256 timestamp;
    }

    Resonance[] public resonances;

    event ResonanceLogged(string project, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResonance(string calldata project, string calldata impact) external onlyAdmin {
        resonances.push(Resonance(project, impact, block.timestamp));
        emit ResonanceLogged(project, impact, block.timestamp);
    }

    function totalResonances() external view returns (uint256) {
        return resonances.length;
    }
}
