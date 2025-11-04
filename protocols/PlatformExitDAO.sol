// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlatformExitDAO {
    address public steward;

    struct ExitEntry {
        string platformName;
        string exitTrigger;
        string userAction;
        string emotionalTag;
    }

    ExitEntry[] public registry;

    event PlatformExitTagged(string platformName, string exitTrigger, string userAction, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagExit(
        string memory platformName,
        string memory exitTrigger,
        string memory userAction,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ExitEntry(platformName, exitTrigger, userAction, emotionalTag));
        emit PlatformExitTagged(platformName, exitTrigger, userAction, emotionalTag);
    }
}
