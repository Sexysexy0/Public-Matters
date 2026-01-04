pragma solidity ^0.8.20;

contract ForensicAnalysisCommonsProtocol {
    address public admin;

    struct Evidence {
        string artifact;     // e.g. log file, memory dump
        string finding;      // e.g. malware trace, unauthorized access
        uint256 timestamp;
    }

    Evidence[] public evidences;

    event EvidenceLogged(string artifact, string finding, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEvidence(string calldata artifact, string calldata finding) external onlyAdmin {
        evidences.push(Evidence(artifact, finding, block.timestamp));
        emit EvidenceLogged(artifact, finding, block.timestamp);
    }

    function totalEvidences() external view returns (uint256) {
        return evidences.length;
    }
}
