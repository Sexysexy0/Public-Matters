// SPDX-License-Identifier: DistrictSanctum
pragma solidity ^0.8.19;

contract DistrictAmnestyRouter {
    struct AmnestyRecord {
        string protestorName;
        string districtName;
        string culturalLanguage;
        bool criminalRecord;
        bool verifiedPeaceful;
        bool amnestyGranted;
        bool restorationActivated;
        string civicNote;
    }

    mapping(bytes32 => AmnestyRecord) public records;

    event DistrictAmnestyTagged(string protestorName, string districtName);
    event AmnestyGranted(string protestorName);
    event CivicRestorationActivated(string protestorName);

    function tagDistrictAmnesty(string memory protestorName, string memory districtName, string memory culturalLanguage, bool criminalRecord, bool verifiedPeaceful, string memory civicNote) public {
        bytes32 recordId = keccak256(abi.encodePacked(protestorName, districtName, block.timestamp));
        records[recordId] = AmnestyRecord(protestorName, districtName, culturalLanguage, criminalRecord, verifiedPeaceful, false, false, civicNote);
        emit DistrictAmnestyTagged(protestorName, districtName);
    }

    function grantAmnesty(string memory protestorName, string memory districtName) public {
        bytes32 recordId = keccak256(abi.encodePacked(protestorName, districtName, block.timestamp));
        records[recordId].amnestyGranted = true;
        emit AmnestyGranted(protestorName);
    }

    function activateRestoration(string memory protestorName, string memory districtName) public {
        bytes32 recordId = keccak256(abi.encodePacked(protestorName, districtName, block.timestamp));
        records[recordId].restorationActivated = true;
        emit CivicRestorationActivated(protestorName);
    }

    function getAmnestyStatus(string memory protestorName, string memory districtName) public view returns (AmnestyRecord memory) {
        bytes32 recordId = keccak256(abi.encodePacked(protestorName, districtName, block.timestamp));
        return records[recordId];
    }
}
