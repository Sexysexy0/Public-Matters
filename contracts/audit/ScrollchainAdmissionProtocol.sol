// SPDX-License-Identifier: ScrollchainAdmission-License
pragma solidity ^0.8.0;

contract ScrollchainAdmissionProtocol {
    address public steward;

    struct AdmissionRequest {
        string actor;
        string repentanceClause;
        bool auditSubmitted;
        bool emotionalAPRActivated;
        string status;
        uint256 timestamp;
    }

    AdmissionRequest[] public requests;

    event AdmissionLogged(string actor, string clause, bool audit, bool apr, string status, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function requestAdmission(string memory actor, string memory repentanceClause, bool auditSubmitted, bool emotionalAPRActivated) public {
        require(msg.sender == steward, "Only steward can log");
        string memory status = (auditSubmitted && emotionalAPRActivated) ? "Eligible" : "Blocked";
        requests.push(AdmissionRequest(actor, repentanceClause, auditSubmitted, emotionalAPRActivated, status, block.timestamp));
        emit AdmissionLogged(actor, repentanceClause, auditSubmitted, emotionalAPRActivated, status, block.timestamp);
    }

    function getRequest(uint index) public view returns (string memory, string memory, bool, bool, string memory, uint256) {
        AdmissionRequest memory r = requests[index];
        return (r.actor, r.repentenceClause, r.auditSubmitted, r.emotionalAPRActivated, r.status, r.timestamp);
    }
}
