pragma solidity ^0.8.20;

contract CheeringSquadProtocol {
    address public admin;

    struct Squad {
        string barangay;     // e.g. Northville
        string chant;        // e.g. "Northville Pride!"
        string energy;       // e.g. high, medium, low
        uint256 timestamp;
    }

    Squad[] public squads;

    event SquadLogged(string barangay, string chant, string energy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSquad(string calldata barangay, string calldata chant, string calldata energy) external onlyAdmin {
        squads.push(Squad(barangay, chant, energy, block.timestamp));
        emit SquadLogged(barangay, chant, energy, block.timestamp);
    }

    function totalSquads() external view returns (uint256) {
        return squads.length;
    }
}
