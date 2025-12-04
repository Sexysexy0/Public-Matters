// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToPowerGridAuditLedger {
    string public batchID = "1321.9.252";
    string public steward = "Vinvin";

    address public admin;

    struct PowerGrid {
        string grid;       // Luzon, Visayas, Mindanao, microgrid
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    PowerGrid[] public grids;

    event PowerGridLogged(string grid, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logGrid(string memory grid, string memory status) public onlyAdmin {
        grids.push(PowerGrid(grid, status, block.timestamp));
        emit PowerGridLogged(grid, status);
    }

    function getGrid(uint256 index) public view returns (string memory grid, string memory status, uint256 timestamp) {
        PowerGrid memory g = grids[index];
        return (g.grid, g.status, g.timestamp);
    }
}
