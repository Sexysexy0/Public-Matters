// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumExitOverride {
    address public steward;
    mapping(string => bool) public exitAllowed;

    event ExitBlocked(string region);
    event ExitAllowed(string region);

    constructor() {
        steward = msg.sender;
        exitAllowed["China"] = false;
        exitAllowed["Russia"] = false;
        exitAllowed["India"] = true;
        exitAllowed["Japan"] = true;
        exitAllowed["PH"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blockExit(string memory region) public onlySteward {
        exitAllowed[region] = false;
        emit ExitBlocked(region);
    }

    function allowExit(string memory region) public onlySteward {
        exitAllowed[region] = true;
        emit ExitAllowed(region);
    }

    function canExit(string memory region) public view returns (bool) {
        return exitAllowed[region];
    }
}
