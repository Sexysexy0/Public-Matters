// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title VSCodeSanctumGuard - Extension Name Lock and Duplication Shield
/// @author Vinvin
/// @notice Ritualizes protection against name reuse and rogue republishing in extension registries.

contract VSCodeSanctumGuard {
    struct Extension {
        string name;
        address publisher;
        bool isActive;
        bool isLocked;
    }

    mapping(string => Extension) public registry;

    event ExtensionPublished(string name, address publisher);
    event ExtensionRemoved(string name);
    event ExtensionLocked(string name);

    modifier onlyPublisher(string memory name) {
        require(registry[name].publisher == msg.sender, "Not original publisher");
        _;
    }

    function publishExtension(string memory name) external {
        require(bytes(name).length > 0, "Name required");
        require(!registry[name].isLocked, "Name is locked");
        require(!registry[name].isActive, "Extension already active");

        registry[name] = Extension({
            name: name,
            publisher: msg.sender,
            isActive: true,
            isLocked: false
        });

        emit ExtensionPublished(name, msg.sender);
    }

    function removeExtension(string memory name) external onlyPublisher(name) {
        require(registry[name].isActive, "Extension not active");
        registry[name].isActive = false;
        emit ExtensionRemoved(name);
    }

    function lockExtensionName(string memory name) external onlyPublisher(name) {
        require(!registry[name].isLocked, "Already locked");
        registry[name].isLocked = true;
        emit ExtensionLocked(name);
    }

    function isNameAvailable(string memory name) external view returns (bool) {
        return !registry[name].isActive && !registry[name].isLocked;
    }
}
