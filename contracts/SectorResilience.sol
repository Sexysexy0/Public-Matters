// contracts/SectorResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SectorResilience
 * @notice Logs sector performance and resilience in crypto markets.
 */
contract SectorResilience {
    address public admin;

    struct Sector {
        string name;        // "Prediction", "DeFi", "NFT"
        int256 change;      // percentage gain/loss
        string verdict;     // "Strong", "Weak"
        uint256 timestamp;
    }

    Sector[] public sectors;

    event SectorLogged(string name, int256 change, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSector(string calldata name, int256 change, string calldata verdict) external onlyAdmin {
        sectors.push(Sector(name, change, verdict, block.timestamp));
        emit SectorLogged(name, change, verdict, block.timestamp);
    }

    function totalSectors() external view returns (uint256) { return sectors.length; }

    function getSector(uint256 id) external view returns (Sector memory) {
        require(id < sectors.length, "Invalid id");
        return sectors[id];
    }
}
