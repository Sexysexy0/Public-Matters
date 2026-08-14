// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataIntegrityLedger {
    struct DataBatch {
        bytes32 dataHash; // Hash ng raw fMRI data
        bytes32 studyId;
        uint256 timestamp;
        address uploader;
    }

    mapping(bytes32 => DataBatch) public dataBatches;
    bytes32[] public batchIds;

    event DataBatchUploaded(bytes32 indexed batchId, bytes32 indexed studyId);

    function uploadDataBatch(
        bytes32 _batchId,
        bytes32 _studyId,
        bytes32 _dataHash
    ) external {
        require(dataBatches[_batchId].uploader == address(0), "Batch already exists");
        dataBatches[_batchId] = DataBatch({
            dataHash: _dataHash,
            studyId: _studyId,
            timestamp: block.timestamp,
            uploader: msg.sender
        });
        batchIds.push(_batchId);
        emit DataBatchUploaded(_batchId, _studyId);
    }

    function verifyDataIntegrity(bytes32 _batchId, bytes32 _dataHash) external view returns (bool) {
        return dataBatches[_batchId].dataHash == _dataHash;
    }
}
