// SPDX-License-Identifier: VisaSanctum
pragma solidity ^0.8.19;

contract StudentVisaSanctifier {
    address public steward;

    struct VisaRecord {
        string name;
        string country;
        string university;
        string visaType; // e.g. F1, J1, M1
        bool sanctified;
        string civicTag; // e.g. "STEM Diplomat", "Civic Contributor"
        uint256 timestamp;
    }

    VisaRecord[] public records;

    event VisaLogged(string name, string country, string university, string visaType, string civicTag, uint256 timestamp);
    event VisaSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logVisa(
        string memory name,
        string memory country,
        string memory university,
        string memory visaType,
        string memory civicTag
    ) public {
        records.push(VisaRecord(name, country, university, visaType, false, civicTag, block.timestamp));
        emit VisaLogged(name, country, university, visaType, civicTag, block.timestamp);
    }

    function sanctifyVisa(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].sanctified = true;
        emit VisaSanctified(index, msg.sender);
    }

    function getVisa(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, string memory, uint256
    ) {
        VisaRecord memory v = records[index];
        return (v.name, v.country, v.university, v.visaType, v.sanctified, v.civicTag, v.timestamp);
    }

    function totalVisas() public view returns (uint256) {
        return records.length;
    }
}
