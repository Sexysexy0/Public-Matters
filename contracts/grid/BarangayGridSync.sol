// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayGridSync {
    event GridSynced(string region, string gridType, bool blessed, uint256 emotionalAPR);
    event GridOverrideTriggered(string region, string reason);

    struct Grid {
        string gridType; // "Solar", "Wind", "Hydro", "Biomass", "SignalMesh"
        bool blessed;
        uint256 emotionalAPR;
    }

    mapping(string => Grid) public grids;
    uint256 public overrideThreshold = 60;

    function syncGrid(string memory region, string memory gridType, bool blessed, uint256 apr) public {
        grids[region] = Grid(gridType, blessed, apr);
        emit GridSynced(region, gridType, blessed, apr);
        if (!blessed || apr < overrideThreshold) {
            emit GridOverrideTriggered(region, "Blessing failed or emotional APR too low");
        }
    }

    function updateOverrideThreshold(uint256 newThreshold) public {
        overrideThreshold = newThreshold;
    }

    function getGrid(string memory region) public view returns (Grid memory) {
        return grids[region];
    }
}
