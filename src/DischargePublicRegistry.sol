// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DischargePublicRegistry {
    address public immutable coreRegistryOwner;

    struct PublicDischargeRecord {
        string facilityId;
        string chemicalCompound;
        uint256 volumePPM;
        uint256 timestamp;
        bool compliant;
    }

    mapping(bytes32 => PublicDischargeRecord) public publicRecords;
    bytes32[] public recordIds;

    event PublicRecordPublished(bytes32 indexed recordId, string facilityId, bool compliant);

    modifier onlyOwner() {
        require(msg.sender == coreRegistryOwner, "DischargePublicRegistry: Unauthorized");
        _;
    }

    constructor() {
        coreRegistryOwner = msg.sender;
    }

    function publishRecord(string memory facilityId, string memory chemicalCompound, uint256 volumePPM, bool compliant)
        external
        onlyOwner
        returns (bytes32)
    {
        bytes32 recordId = keccak256(abi.encode(facilityId, chemicalCompound, block.timestamp));

        publicRecords[recordId] = PublicDischargeRecord({
            facilityId: facilityId,
            chemicalCompound: chemicalCompound,
            volumePPM: volumePPM,
            timestamp: block.timestamp,
            compliant: compliant
        });

        recordIds.push(recordId);
        emit PublicRecordPublished(recordId, facilityId, compliant);
        return recordId;
    }
}
