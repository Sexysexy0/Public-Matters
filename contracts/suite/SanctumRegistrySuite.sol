// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SanctumRegistrySuite - Mythic Registry for Extension Sanctums and Civic Modules
/// @author Vinvin
/// @notice Ritualizes extension publishing, name locking, emotional APR tagging, and audit-ready broadcasts.

contract SanctumRegistrySuite {
    struct Sanctum {
        string name;
        address publisher;
        bool isActive;
        bool isLocked;
        string emotionalAPR; // e.g. "Empathy:92,Trust:88,Clarity:95"
    }

    mapping(string => Sanctum) public sanctums;

    event SanctumPublished(string name, address publisher, string emotionalAPR);
    event SanctumRemoved(string name);
    event SanctumLocked(string name);
    event EmotionalAPRUpdated(string name, string newAPR);

    modifier onlyPublisher(string memory name) {
        require(sanctums[name].publisher == msg.sender, "Not original publisher");
        _;
    }

    function publishSanctum(string memory name, string memory emotionalAPR) external {
        require(bytes(name).length > 0, "Name required");
        require(!sanctums[name].isLocked, "Name is locked");
        require(!sanctums[name].isActive, "Sanctum already active");

        sanctums[name] = Sanctum({
            name: name,
            publisher: msg.sender,
            isActive: true,
            isLocked: false,
            emotionalAPR: emotionalAPR
        });

        emit SanctumPublished(name, msg.sender, emotionalAPR);
    }

    function removeSanctum(string memory name) external onlyPublisher(name) {
        require(sanctums[name].isActive, "Sanctum not active");
        sanctums[name].isActive = false;
        emit SanctumRemoved(name);
    }

    function lockSanctumName(string memory name) external onlyPublisher(name) {
        require(!sanctums[name].isLocked, "Already locked");
        sanctums[name].isLocked = true;
        emit SanctumLocked(name);
    }

    function updateEmotionalAPR(string memory name, string memory newAPR) external onlyPublisher(name) {
        require(sanctums[name].isActive, "Sanctum not active");
        sanctums[name].emotionalAPR = newAPR;
        emit EmotionalAPRUpdated(name, newAPR);
    }

    function isNameAvailable(string memory name) external view returns (bool) {
        return !sanctums[name].isActive && !sanctums[name].isLocked;
    }

    function getSanctumAPR(string memory name) external view returns (string memory) {
        return sanctums[name].emotionalAPR;
    }
}
