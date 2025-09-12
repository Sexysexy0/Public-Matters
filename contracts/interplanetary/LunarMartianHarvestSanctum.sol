// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LunarMartianHarvestSanctum {
    enum CelestialBody { Moon, Mars }
    enum DepositType { Helium3, Regolith, Ice, RareEarth, Unknown }
    enum ToolType { Drill, Extractor, Refiner, Transporter }

    struct MiningSanctum {
        uint256 sanctumId;
        CelestialBody body;
        string locationTag;
        DepositType deposit;
        ToolType[] tools;
        uint256 harvestRate;
        bool operational;
        uint256 timestamp;
    }

    mapping(uint256 => MiningSanctum) public sanctumRegistry;
    uint256 public sanctumCount;

    event SanctumDeployed(uint256 id, CelestialBody body, DepositType deposit);
    event SanctumActivated(uint256 id);
    event SanctumDecommissioned(uint256 id);

    function deploySanctum(
        CelestialBody body,
        string memory locationTag,
        DepositType deposit,
        ToolType[] memory tools,
        uint256 harvestRate,
        uint256 timestamp
    ) public {
        sanctumRegistry[sanctumCount] = MiningSanctum(
            sanctumCount,
            body,
            locationTag,
            deposit,
            tools,
            harvestRate,
            true,
            timestamp
        );
        emit SanctumDeployed(sanctumCount, body, deposit);
        sanctumCount++;
    }

    function deactivateSanctum(uint256 id) public {
        sanctumRegistry[id].operational = false;
        emit SanctumDecommissioned(id);
    }

    function activateSanctum(uint256 id) public {
        sanctumRegistry[id].operational = true;
        emit SanctumActivated(id);
    }

    function getSanctum(uint256 id) public view returns (MiningSanctum memory) {
        return sanctumRegistry[id];
    }
}
