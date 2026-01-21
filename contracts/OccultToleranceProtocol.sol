pragma solidity ^0.8.20;

contract OccultToleranceProtocol {
    address public admin;

    struct Tolerance {
        string practice;     // e.g. witchcraft, occult rituals
        string acceptance;   // e.g. condoned by institutions, normalized in culture
        uint256 timestamp;
    }

    Tolerance[] public tolerances;

    event ToleranceLogged(string practice, string acceptance, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTolerance(string calldata practice, string calldata acceptance) external onlyAdmin {
        tolerances.push(Tolerance(practice, acceptance, block.timestamp));
        emit ToleranceLogged(practice, acceptance, block.timestamp);
    }

    function totalTolerances() external view returns (uint256) {
        return tolerances.length;
    }
}
