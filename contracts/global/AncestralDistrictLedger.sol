// SPDX-License-Identifier: AncestralSanctum
pragma solidity ^0.8.19;

contract AncestralDistrictLedger {
    struct DistrictRecord {
        string districtName;
        string culturalLanguage;
        string ancestralLineage;
        bool recognizedByState;
        bool returnRightsActivated;
        string dignityNote;
    }

    mapping(bytes32 => DistrictRecord) public records;

    event DistrictTagged(string districtName, string culturalLanguage);
    event ReturnRightsActivated(string districtName);

    function tagDistrict(string memory districtName, string memory culturalLanguage, string memory ancestralLineage, bool recognizedByState, string memory dignityNote) public {
        bytes32 recordId = keccak256(abi.encodePacked(districtName, culturalLanguage, block.timestamp));
        records[recordId] = DistrictRecord(districtName, culturalLanguage, ancestralLineage, recognizedByState, false, dignityNote);
        emit DistrictTagged(districtName, culturalLanguage);
    }

    function activateReturnRights(string memory districtName, string memory culturalLanguage) public {
        bytes32 recordId = keccak256(abi.encodePacked(districtName, culturalLanguage, block.timestamp));
        records[recordId].returnRightsActivated = true;
        emit ReturnRightsActivated(districtName);
    }

    function getDistrictStatus(string memory districtName, string memory culturalLanguage) public view returns (DistrictRecord memory) {
        bytes32 recordId = keccak256(abi.encodePacked(districtName, culturalLanguage, block.timestamp));
        return records[recordId];
    }
}
