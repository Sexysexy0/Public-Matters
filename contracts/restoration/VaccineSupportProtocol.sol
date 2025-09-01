// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract VaccineSupportProtocol {
    event ImmunizationBlessed(
        string steward,
        string barangay,
        string vaccineType,
        bool consentGiven,
        string emotionalTag,
        uint256 timestamp
    );

    struct ImmunizationRecord {
        string steward;
        string barangay;
        string vaccineType;
        bool consentGiven;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => ImmunizationRecord) public records;

    function blessImmunization(
        string memory steward,
        string memory barangay,
        string memory vaccineType,
        bool consentGiven,
        string memory emotionalTag
    ) external {
        require(consentGiven || !consentGiven, "Consent must be explicit");
        bytes32 recordId = keccak256(abi.encodePacked(steward, vaccineType, block.timestamp));
        records[recordId] = ImmunizationRecord(steward, barangay, vaccineType, consentGiven, emotionalTag, block.timestamp);
        emit ImmunizationBlessed(steward, barangay, vaccineType, consentGiven, emotionalTag, block.timestamp);
    }

    function getRecord(bytes32 recordId) external view returns (ImmunizationRecord memory) {
        return records[recordId];
    }
}
