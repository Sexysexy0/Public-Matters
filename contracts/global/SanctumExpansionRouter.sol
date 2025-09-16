// SPDX-License-Identifier: ExpansionSanctum
pragma solidity ^0.8.19;

contract SanctumExpansionRouter {
    struct ExpansionSignal {
        address steward;
        string sanctumName;
        uint256 originalCapacity;
        uint256 newCapacity;
        string expansionType; // e.g., "Family Inclusion", "Elder Wing", "Child-Safe Upgrade"
        bool dignityCertified;
        bool verified;
        string stewardNote;
    }

    mapping(address => ExpansionSignal) public expansionRegistry;

    event ExpansionTagged(address steward, string expansionType);
    event ExpansionVerified(address steward);

    function tagExpansion(address steward, string memory sanctumName, uint256 originalCapacity, uint256 newCapacity, string memory expansionType, bool dignityCertified, string memory stewardNote) public {
        expansionRegistry[steward] = ExpansionSignal(steward, sanctumName, originalCapacity, newCapacity, expansionType, dignityCertified, false, stewardNote);
        emit ExpansionTagged(steward, expansionType);
    }

    function verifyExpansion(address steward) public {
        require(bytes(expansionRegistry[steward].expansionType).length > 0, "Expansion not tagged");
        expansionRegistry[steward].verified = true;
        emit ExpansionVerified(steward);
    }

    function getExpansionStatus(address steward) public view returns (ExpansionSignal memory) {
        return expansionRegistry[steward];
    }
}
