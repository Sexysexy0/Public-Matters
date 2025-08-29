// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CyberResilienceEnhanced {
    address public client;         // Nevada State Authority wallet
    address public contractor;     // Stewardship Entity wallet
    string public purpose;
    uint256 public startDate;

    enum Phase { Containment, CoreRestoration, FullRestoration, PostAudit, Complete }
    Phase public currentPhase;

    struct Deliverable {
        string name;
        string description;
        bool completed;
        uint256 completedAt;
    }

    mapping(uint => Deliverable) public deliverables;
    uint public deliverableCount;

    struct SecurityEvent {
        string details;
        uint256 timestamp;
        address triggeredBy;
    }

    SecurityEvent[] public securityLog;

    modifier onlyClient() {
        require(msg.sender == client, "Not authorized: client only");
        _;
    }

    modifier onlyContractor() {
        require(msg.sender == contractor, "Not authorized: contractor only");
        _;
    }

    event PhaseAdvanced(Phase newPhase, uint256 timestamp);
    event DeliverableCompleted(uint deliverableId, string name, uint256 timestamp);
    event SecurityIncidentLogged(string details, uint256 timestamp);

    constructor(address _client, address _contractor, string memory _purpose) {
        client = _client;
        contractor = _contractor;
        purpose = _purpose;
        startDate = block.timestamp;
        currentPhase = Phase.Containment;
    }

    // Add deliverables
    function addDeliverable(string memory _name, string memory _desc) public onlyContractor {
        deliverables[deliverableCount] = Deliverable(_name, _desc, false, 0);
        deliverableCount++;
    }

    // Mark as complete
    function markDeliverableComplete(uint _id) public onlyContractor {
        require(_id < deliverableCount, "Invalid deliverable ID");
        deliverables[_id].completed = true;
        deliverables[_id].completedAt = block.timestamp;
        emit DeliverableCompleted(_id, deliverables[_id].name, block.timestamp);
    }

    // Advance project phase
    function advancePhase() public onlyClient {
        require(uint(currentPhase) < uint(Phase.Complete), "All phases done");
        currentPhase = Phase(uint(currentPhase) + 1);
        emit PhaseAdvanced(currentPhase, block.timestamp);
    }

    // Security event log
    function logSecurityIncident(string memory _details) public {
        securityLog.push(SecurityEvent(_details, block.timestamp, msg.sender));
        emit SecurityIncidentLogged(_details, block.timestamp);
    }

    // Mythic Stewardship Clause
    function getReplicationRights() public pure returns (string memory) {
        return "All frameworks, blueprints, and security protocols may be replicated for free to aid other communities.";
    }

    // View counts
    function getSecurityLogCount() public view returns (uint) {
        return securityLog.length;
    }
}
