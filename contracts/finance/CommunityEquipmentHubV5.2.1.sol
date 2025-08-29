// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityEquipmentHubV521 {
    address public steward;
    uint256 public equipCount;
    uint256 public coopCount;

    constructor() { steward = msg.sender; }
    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    struct Equipment {
        uint256 id;
        string name;
        string category; // tailoring, baking, carpentry, etc.
        uint256 unitsAvailable;
        string barangay;
        bool inUse;
    }

    struct Cooperative {
        uint256 id;
        string name;
        string barangay;
        string focus; // tailoring, baking, etc.
        address[] members;
        uint256[] equipmentIds;
    }

    mapping(uint256 => Equipment) public equipments;
    mapping(uint256 => Cooperative) public cooperatives;

    event EquipmentProvided(uint256 id, string name, string barangay, uint256 unitsAvailable);
    event CooperativeFormed(uint256 id, string name, string barangay, string focus);

    function provideEquipment(
        string calldata name,
        string calldata category,
        uint256 unitsAvailable,
        string calldata barangay
    ) external onlySteward {
        equipCount++;
        equipments[equipCount] = Equipment(equipCount, name, category, unitsAvailable, barangay, false);
        emit EquipmentProvided(equipCount, name, barangay, unitsAvailable);
    }

    function formCooperative(
        string calldata name,
        string calldata barangay,
        string calldata focus,
        address[] calldata members,
        uint256[] calldata equipmentIds
    ) external onlySteard {
        coopCount++;
        cooperatives[coopCount] = Cooperative(coopCount, name, barangay, focus, members, equipmentIds);
        emit CooperativeFormed(coopCount, name, barangay, focus);
    }
}
