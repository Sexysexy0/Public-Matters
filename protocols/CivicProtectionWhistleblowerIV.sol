// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * CivicProtectionWhistleblowerIV — Batch 1321.9.261
 * Seal: Protect whistleblowers and public access to information
 */
contract CivicProtectionWhistleblowerIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Report {
        string caseId;
        string summary;
        string evidenceUri;   // IPFS/URI
        bool anonymity;       // requested anonymity
        uint256 timestamp;
    }

    struct FOI {
        string requestId;
        string subject;
        string responseUri;   // publication link
        uint256 timestamp;
    }

    mapping(bytes32 => Report[]) public wbReports;
    mapping(bytes32 => FOI[]) public foiLogs;

    event WhistleblowerReport(bytes32 indexed key, string caseId, bool anonymity, string evidenceUri);
    event FOIResponded(bytes32 indexed key, string requestId, string subject, string responseUri);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory subjectId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(subjectId));
    }

    function logWhistleblowerReport(
        string calldata subjectId,
        string calldata caseId,
        string calldata summary,
        string calldata evidenceUri,
        bool anonymity
    ) external onlySteward {
        bytes32 k = keyFor(subjectId);
        wbReports[k].push(Report(caseId, summary, evidenceUri, anonymity, block.timestamp));
        emit WhistleblowerReport(k, caseId, anonymity, evidenceUri);
    }

    function logFOIResponse(
        string calldata subjectId,
        string calldata requestId,
        string calldata subject,
        string calldata responseUri
    ) external onlySteward {
        bytes32 k = keyFor(subjectId);
        foiLogs[k].push(FOI(requestId, subject, responseUri, block.timestamp));
        emit FOIResponded(k, requestId, subject, responseUri);
    }

    function wbCount(string calldata subjectId) external view returns (uint256) {
        return wbReports[keyFor(subjectId)].length;
    }

    function foiCount(string calldata subjectId) external view returns (uint256) {
        return foiLogs[keyFor(subjectId)].length;
    }
}
