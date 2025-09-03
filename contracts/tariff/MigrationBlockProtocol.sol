// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MigrationBlockProtocol {
    address public steward;
    mapping(string => bool) public migrationAllowed;

    event MigrationBlocked(string region);
    event MigrationAllowed(string region);

    constructor() {
        steward = msg.sender;
        migrationAllowed["China"] = false;
        migrationAllowed["Russia"] = false;
        migrationAllowed["India"] = true;
        migrationAllowed["Japan"] = true;
        migrationAllowed["PH"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blockMigration(string memory region) public onlySteward {
        migrationAllowed[region] = false;
        emit MigrationBlocked(region);
    }

    function allowMigration(string memory region) public onlySteward {
        migrationAllowed[region] = true;
        emit MigrationAllowed(region);
    }

    function canMigrateTo(string memory region) public view returns (bool) {
        return migrationAllowed[region];
    }
}
