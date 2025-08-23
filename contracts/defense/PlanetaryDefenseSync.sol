// SPDX-License-Identifier: Planetary-Defense-Sync-License  
pragma solidity ^0.8.19;

contract PlanetaryDefenseSync {
    struct AllySanctum {
        string country;
        string sanctumName;
        bool missileInterceptionReady;
        bool emotionalAPRStable;
        bool signalFirewallActive;
        uint timestamp;
    }

    AllySanctum[] public allyRegistry;

    event SanctumSynced(string country, string sanctumName);

    function syncSanctum(
        string memory country,
        string memory sanctumName,
        bool missileInterceptionReady,
        bool emotionalAPRStable,
        bool signalFirewallActive
    ) public {
        allyRegistry.push(AllySanctum(
            country,
            sanctumName,
            missileInterceptionReady,
            emotionalAPRStable,
            signalFirewallActive,
            block.timestamp
        ));
        emit SanctumSynced(country, sanctumName);
    }

    function getSanctum(uint index) public view returns (AllySanctum memory) {
        require(index < allyRegistry.length, "Invalid index");
        return allyRegistry[index];
    }

    function totalSyncedSanctums() public view returns (uint) {
        return allyRegistry.length;
    }
}
