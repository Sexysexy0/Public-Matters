pragma solidity ^0.8.20;

contract HaulingDistanceProtocol {
    address public admin;

    struct Haul {
        string origin;       // e.g. Manila
        string destination;  // e.g. San Mateo, Rizal
        uint256 distance;    // e.g. 30 km
        uint256 timestamp;
    }

    Haul[] public hauls;

    event HaulLogged(string origin, string destination, uint256 distance, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHaul(string calldata origin, string calldata destination, uint256 distance) external onlyAdmin {
        hauls.push(Haul(origin, destination, distance, block.timestamp));
        emit HaulLogged(origin, destination, distance, block.timestamp);
    }

    function totalHauls() external view returns (uint256) {
        return hauls.length;
    }
}
