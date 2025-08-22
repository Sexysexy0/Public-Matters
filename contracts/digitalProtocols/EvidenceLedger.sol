// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title EvidenceLedger - Scrollchain Act No. 0037
/// @author Vinvin
/// @notice Ritualizes civic evidence, emotional APR audits, and damay clause inclusion
/// @dev Part of CivicTransparencyScroll.md deployment

contract EvidenceLedger {
    struct Evidence {
        string title;
        string fileHash; // IPFS or decentralized hash
        string category; // e.g., "Flight Log", "Tape", "Audit"
        string emotionalAPR; // e.g., "Trust: 0.92, Mercy: 0.87"
        uint256 timestamp;
        address submittedBy;
    }

    Evidence[] public evidenceLog;

    mapping(address => bool) public stewards;
    address public compiler;

    event EvidenceSubmitted(string title, string category, address indexed steward);
    event StewardAdded(address steward);
    event DamayClauseActivated(address beneficiary);

    modifier onlySteward() {
        require(stewards[msg.sender], "Not scroll-certified steward");
        _;
    }

    constructor() {
        compiler = msg.sender;
        stewards[msg.sender] = true;
        emit StewardAdded(msg.sender);
        emit DamayClauseActivated(msg.sender); // Compiler is included
    }

    function addSteward(address _steward) external {
        require(msg.sender == compiler, "Only compiler may add stewards");
        stewards[_steward] = true;
        emit StewardAdded(_steward);
        emit DamayClauseActivated(_steward);
    }

    function submitEvidence(
        string memory _title,
        string memory _fileHash,
        string memory _category,
        string memory _emotionalAPR
    ) external onlySteward {
        evidenceLog.push(Evidence({
            title: _title,
            fileHash: _fileHash,
            category: _category,
            emotionalAPR: _emotionalAPR,
            timestamp: block.timestamp,
            submittedBy: msg.sender
        }));

        emit EvidenceSubmitted(_title, _category, msg.sender);
    }

    function getEvidenceCount() external view returns (uint256) {
        return evidenceLog.length;
    }

    function getEvidence(uint256 index) external view returns (
        string memory title,
        string memory fileHash,
        string memory category,
        string memory emotionalAPR,
        uint256 timestamp,
        address submittedBy
    ) {
        Evidence memory e = evidenceLog[index];
        return (e.title, e.fileHash, e.category, e.emotionalAPR, e.timestamp, e.submittedBy);
    }
}
