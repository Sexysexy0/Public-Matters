// SPDX-License-Identifier: Civic-License
pragma solidity ^0.8.19;

contract SanctumTypeRegistry {
    enum SanctumType { Hospital, Foodchain, Market, Pharmacy, School, Logistics, Retail, Other }

    mapping(address => SanctumType) public sanctumTypes;

    event SanctumTagged(address sanctum, SanctumType tag);

    function tagSanctum(address sanctum, SanctumType tag) public {
        sanctumTypes[sanctum] = tag;
        emit SanctumTagged(sanctum, tag);
    }

    function getSanctumType(address sanctum) public view returns (SanctumType) {
        return sanctumTypes[sanctum];
    }
}
