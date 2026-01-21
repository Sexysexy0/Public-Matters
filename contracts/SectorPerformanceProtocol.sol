pragma solidity ^0.8.20;

contract SectorPerformanceProtocol {
    address public admin;

    struct Sector {
        string name;         // e.g. Gambling, DeFi, AI
        int256 change;       // e.g. +10% performance
        uint256 timestamp;
    }

    Sector[] public sectors;

    event SectorLogged(string name, int256 change, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSector(string calldata name, int256 change) external onlyAdmin {
        sectors.push(Sector(name, change, block.timestamp));
        emit SectorLogged(name, change, block.timestamp);
    }

    function totalSectors() external view returns (uint256) {
        return sectors.length;
    }
}
