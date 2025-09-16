// SPDX-License-Identifier: SanctumRegistry
pragma solidity ^0.8.19;

contract IntergenerationalSanctumRouter {
    struct SanctumSignal {
        address steward;
        string householdName;
        uint256 totalMembers;
        uint256 elders;
        uint256 children;
        string shelterType; // e.g., "Permanent", "Transitional", "Urban", "Rural"
        bool dignityCertified;
        bool verified;
        string stewardNote;
    }

    mapping(address => SanctumSignal) public sanctumRegistry;

    event SanctumTagged(address steward, string shelterType);
    event SanctumVerified(address steward);

    function tagSanctum(address steward, string memory householdName, uint256 totalMembers, uint256 elders, uint256 children, string memory shelterType, bool dignityCertified, string memory stewardNote) public {
        sanctumRegistry[steward] = SanctumSignal(steward, householdName, totalMembers, elders, children, shelterType, dignityCertified, false, stewardNote);
        emit SanctumTagged(steward, shelterType);
    }

    function verifySanctum(address steward) public {
        require(bytes(sanctumRegistry[steward].shelterType).length > 0, "Sanctum not tagged");
        sanctumRegistry[steward].verified = true;
        emit SanctumVerified(steward);
    }

    function getSanctumStatus(address steward) public view returns (SanctumSignal memory) {
        return sanctumRegistry[steward];
    }
}
