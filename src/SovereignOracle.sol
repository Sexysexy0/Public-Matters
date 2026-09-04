// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract SovereignOracle {
    address public admin;
    mapping(bytes32 => bytes) public records;

    event RecordSet(bytes32 indexed key, bytes value);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function setRecord(bytes32 _key, bytes memory _value) public onlyAdmin {
        records[_key] = _value;
        emit RecordSet(_key, _value);
    }

    function getRecord(bytes32 _key) public view returns (bytes memory) {
        return records[_key];
    }

    function setEnvironmentalReport(string memory _location, bytes memory _data) public onlyAdmin {
        bytes32 key = keccak256(abi.encodePacked("env:", _location));
        records[key] = _data;
        emit RecordSet(key, _data);
    }

    function getEnvironmentalReport(string memory _location) public view returns (bytes memory) {
        bytes32 key = keccak256(abi.encodePacked("env:", _location));
        return records[key];
    }
}
