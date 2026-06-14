// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract FinancialIndexReconstitutionOracle {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public constant SCALE_FACTOR = 1000000; // 6 decimals precision (1.000000 = 100%)
    uint256 public totalIndexes;

    struct IndexProfile {
        uint256 id;
        string indexName;
        uint256 activeConstituentsCount;
        uint256 lastReconstitutionTimestamp;
        bool isLocked;
    }

    mapping(uint256 => IndexProfile) public indexes;
    mapping(uint256 => mapping(address => uint256)) public constituentWeights; // indexId => asset => weight
    mapping(address => bool) public approvedIndexCommittees;

    event IndexInitiated(uint256 indexed indexId, string indexName);
    event ReconstitutionExecuted(uint256 indexed indexId, uint256 timestamp, bytes32 validationHash);
    event CommitteeStatusUpdated(address indexed committee, bool status);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    modifier onlyCommittee() {
        require(approvedIndexCommittees[msg.sender] || msg.sender == sovereignContractor, "Error: Unauthorized committee node.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function setCommitteeClearance(address _committee, bool _status) public onlyContractor {
        approvedIndexCommittees[_committee] = _status;
        emit CommitteeStatusUpdated(_committee, _status);
    }

    function initiateIndex(string memory _name) public onlyContractor returns (uint256) {
        totalIndexes++;
        indexes[totalIndexes] = IndexProfile({
            id: totalIndexes,
            indexName: _name,
            activeConstituentsCount: 0,
            lastReconstitutionTimestamp: block.timestamp,
            isLocked: false
        });
        emit IndexInitiated(totalIndexes, _name);
        return totalIndexes;
    }

    /**
     * @dev MORNINGSTAR WEIGHT CHECK LOOP: Sapilitang nirerequire na ang sum ng weights 
     * ng lahat ng ipapasang constituents ay papatak sa eksaktong SCALE_FACTOR (100%).
     */
    function executeIndexReconstitution(
        uint256 _indexId,
        address[] memory _assets,
        uint256[] memory _weights,
        bytes32 _reconstitutionHash
    ) public onlyCommittee {
        IndexProfile storage idx = indexes[_indexId];
        require(!idx.isLocked, "Error: Index family is locked.");
        require(_assets.length == _weights.length, "Error: Matrix dimensions mismatch.");
        require(_assets.length > 0, "Error: Empty index constituent payload.");

        uint256 totalWeightSum = 0;
        for (uint256 i = 0; i < _assets.length; i++) {
            require(_assets[i] != address(0), "Error: Invalid asset pointer.");
            constituentWeights[_indexId][_assets[i]] = _weights[i];
            totalWeightSum += _weights[i];
        }

        // Sapilitang cross-verification (Must equal 1.000000)
        require(totalWeightSum == SCALE_FACTOR, "Error: Mismatch identified. Weights sum must equal exactly 100%.");

        idx.lastReconstitutionTimestamp = block.timestamp;
        idx.activeConstituentsCount = _assets.length;

        emit ReconstitutionExecuted(_indexId, block.timestamp, _reconstitutionHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(msg.sender, 0, 1, 0, _reconstitutionHash) {} catch {}
        }
    }
}
