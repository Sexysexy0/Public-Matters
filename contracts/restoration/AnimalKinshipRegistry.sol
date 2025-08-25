// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AnimalKinshipRegistry {
    address public steward;

    struct KinshipRecord {
        address feeder;
        string animalType;
        string location;
        uint256 encounterCount;
        string emotionalBond;
        bool trustEstablished;
        uint256 lastEncounter;
    }

    mapping(bytes32 => KinshipRecord) public kinshipLog;

    event KinshipUpdated(
        address indexed feeder,
        string animalType,
        string location,
        uint256 encounterCount,
        string emotionalBond,
        bool trustEstablished,
        uint256 lastEncounter
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function updateKinship(
        string memory animalType,
        string memory location,
        string memory emotionalBond,
        bool trustEstablished
    ) public {
        bytes32 recordId = keccak256(abi.encodePacked(msg.sender, animalType, location));
        KinshipRecord storage record = kinshipLog[recordId];

        record.feeder = msg.sender;
        record.animalType = animalType;
        record.location = location;
        record.encounterCount += 1;
        record.emotionalBond = emotionalBond;
        record.trustEstablished = trustEstablished;
        record.lastEncounter = block.timestamp;

        emit KinshipUpdated(
            msg.sender,
            animalType,
            location,
            record.encounterCount,
            emotionalBond,
            trustEstablished,
            block.timestamp
        );
    }

    function getKinshipRecord(string memory animalType, string memory location) public view returns (KinshipRecord memory) {
        bytes32 recordId = keccak256(abi.encodePacked(msg.sender, animalType, location));
        return kinshipLog[recordId];
    }
}
