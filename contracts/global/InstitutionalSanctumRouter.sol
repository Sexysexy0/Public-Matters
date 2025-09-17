// SPDX-License-Identifier: SanctumDefense
pragma solidity ^0.8.19;

contract InstitutionalSanctumRouter {
    struct SanctumSignal {
        address institutionID;
        string institutionName;
        string sanctumType; // e.g., "Judicial", "Legislative", "Regulatory", "Electoral"
        bool firewallActivated;
        string stewardNote;
    }

    mapping(address => SanctumSignal) public sanctumRegistry;

    event SanctumTagged(address institutionID, string sanctumType);
    event FirewallActivated(address institutionID);

    function tagSanctum(address institutionID, string memory institutionName, string memory sanctumType, string memory stewardNote) public {
        sanctumRegistry[institutionID] = SanctumSignal(institutionID, institutionName, sanctumType, false, stewardNote);
        emit SanctumTagged(institutionID, sanctumType);
    }

    function activateFirewall(address institutionID) public {
        require(bytes(sanctumRegistry[institutionID].institutionName).length > 0, "Sanctum not tagged");
        sanctumRegistry[institutionID].firewallActivated = true;
        emit FirewallActivated(institutionID);
    }

    function getSanctumStatus(address institutionID) public view returns (SanctumSignal memory) {
        return sanctumRegistry[institutionID];
    }
}
