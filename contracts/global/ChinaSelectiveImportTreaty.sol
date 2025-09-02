// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.8.19;

contract ChinaSelectiveImportTreaty {
    address public steward;
    mapping(string => bool) public allowedImports;
    mapping(string => bool) public allowedExports;

    modifier onlySteward() {
        require(msg.sender == steward, "Not scroll-certified.");
        _;
    }

    constructor() {
        steward = msg.sender;

        // ✅ Allowed Imports/Exports (with conditional blessing)
        allowedImports["food"] = true; // Only if matched by desired import goods
        allowedExports["food"] = true;

        allowedImports["rare_earth"] = true;
        allowedExports["rare_earth"] = true;

        allowedImports["gas"] = true;
        allowedExports["gas"] = true;

        allowedImports["appliances"] = true;
        allowedExports["appliances"] = true;

        // ❌ Forbidden Imports/Exports
        allowedImports["chipsets"] = false;
        allowedExports["chipsets"] = false;

        allowedImports["electric_vehicles"] = false;
        allowedExports["electric_vehicles"] = false;
    }

    function isImportAllowed(string memory item) public view returns (bool) {
        return allowedImports[item];
    }

    function isExportAllowed(string memory item) public view returns (bool) {
        return allowedExports[item];
    }

    function updateImportPermission(string memory item, bool status) public onlySteward {
        allowedImports[item] = status;
        emit ImportPermissionUpdated(item, status);
    }

    function updateExportPermission(string memory item, bool status) public onlySteward {
        allowedExports[item] = status;
        emit ExportPermissionUpdated(item, status);
    }

    event ImportPermissionUpdated(string item, bool status);
    event ExportPermissionUpdated(string item, bool status);
}
