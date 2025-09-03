// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ImportExportRevocation {
    address public steward;
    mapping(string => bool) public importAccess;
    mapping(string => bool) public exportAccess;

    event ImportRevoked(string region);
    event ExportRevoked(string region);
    event ImportGranted(string region);
    event ExportGranted(string region);

    constructor() {
        steward = msg.sender;
        importAccess["China"] = false;
        exportAccess["China"] = false;
        importAccess["Russia"] = false;
        exportAccess["Russia"] = false;
        importAccess["India"] = true;
        exportAccess["India"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function revokeImport(string memory region) public onlySteward {
        importAccess[region] = false;
        emit ImportRevoked(region);
    }

    function revokeExport(string memory region) public onlySteward {
        exportAccess[region] = false;
        emit ExportRevoked(region);
    }

    function grantImport(string memory region) public onlySteward {
        importAccess[region] = true;
        emit ImportGranted(region);
    }

    function grantExport(string memory region) public onlySteward {
        exportAccess[region] = true;
        emit ExportGranted(region);
    }

    function canImport(string memory region) public view returns (bool) {
        return importAccess[region];
    }

    function canExport(string memory region) public view returns (bool) {
        return exportAccess[region];
    }
}
