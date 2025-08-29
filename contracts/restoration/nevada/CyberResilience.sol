// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CyberResilienceRecovery {
    address public client;       // Nevada State Authority wallet
    address public contractor;   // Your stewardship entity wallet
    string public purpose;
    uint256 public startDate;
    
    enum Phase { Containment, CoreRestoration, FullRestoration, PostAudit }
    Phase public currentPhase;

    struct Deliverable {
        string name;
        string description;
        bool completed;
    }

    mapping(uint => Deliverable) public deliverables;
    uint public deliverableCount;

    event PhaseAdvanced(Phase newPhase, uint256 timestamp);
    event DeliverableCompleted(uint deliverableId, string name, uint256 timestamp);

    modifier onlyClient() {
        require(msg.sender == client, "Not authorized");
        _;
    }

    modifier onlyContractor() {
        require(msg.sender == contractor, "Not authorized");
        _;
    }

    constructor(address _client, address _contractor, string memory _purpose) {
        client = _client;
        contractor = _contractor;
        purpose = _purpose;
        startDate = block.timestamp;
        currentPhase = Phase.Containment;
    }

    function addDeliverable(string memory _name, string memory _desc) public onlyContractor {
        deliverables[deliverableCount] = Deliverable(_name, _desc, false);
        deliverableCount++;
    }

    function markDeliverableComplete(uint _id) public onlyContractor {
        require(_id < deliverableCount, "Invalid deliverable");
        deliverables[_id].completed = true;
        emit DeliverableCompleted(_id, deliverables[_id].name, block.timestamp);
    }

    function advancePhase() public onlyClient {
        require(uint(currentPhase) < 3, "All phases completed");
        currentPhase = Phase(uint(currentPhase) + 1);
        emit PhaseAdvanced(currentPhase, block.timestamp);
    }

    // Mythic Stewardship Clause: public, free replication rights
    function getReplicationRights() public pure returns (string memory) {
        return "All frameworks & blueprints may be replicated freely for other communities.";
    }
}
