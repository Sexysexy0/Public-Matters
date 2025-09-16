// SPDX-License-Identifier: HeritageSanctum
pragma solidity ^0.8.19;

contract HeritageSanctumRouter {
    struct SanctumSignal {
        string siteID;
        string culture;
        string restorationTreaty;
        bool blessed;
        string stewardNote;
    }

    mapping(string => SanctumSignal) public sanctumRegistry;

    event SanctumTagged(string siteID, string culture);
    event SanctumBlessed(string siteID);

    function tagSanctum(string memory siteID, string memory culture, string memory restorationTreaty, string memory stewardNote) public {
        sanctumRegistry[siteID] = SanctumSignal(siteID, culture, restorationTreaty, false, stewardNote);
        emit SanctumTagged(siteID, culture);
    }

    function blessSanctum(string memory siteID) public {
        require(bytes(sanctumRegistry[siteID].culture).length > 0, "Sanctum not tagged");
        sanctumRegistry[siteID].blessed = true;
        emit SanctumBlessed(siteID);
    }

    function getSanctumStatus(string memory siteID) public view returns (SanctumSignal memory) {
        return sanctumRegistry[siteID];
    }
}
