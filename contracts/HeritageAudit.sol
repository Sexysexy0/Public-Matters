// contracts/HeritageAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HeritageAudit
 * @notice Communal audit of heritage sites and public markets for preservation.
 */
contract HeritageAudit {
    address public admin;

    struct Heritage {
        string site;
        string status;   // "Preserved", "Threatened"
        string note;
        uint256 timestamp;
    }

    Heritage[] public heritageSites;

    event HeritageLogged(string site, string status, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logHeritage(string calldata site, string calldata status, string calldata note) external onlyAdmin {
        heritageSites.push(Heritage(site, status, note, block.timestamp));
        emit HeritageLogged(site, status, note, block.timestamp);
    }

    function totalHeritage() external view returns (uint256) { return heritageSites.length; }

    function getHeritage(uint256 id) external view returns (Heritage memory) {
        require(id < heritageSites.length, "Invalid id");
        return heritageSites[id];
    }
}
