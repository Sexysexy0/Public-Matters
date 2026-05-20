// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * IncidentResponseBridge
 * Governance contract para sa automated incident response.
 * - Owner: highest authority (Vinvin)
 * - Members: security coders / responders
 * - Functions: trigger response, assign responders, resolve incident
 */
contract IncidentResponseBridge {
    address public owner;
    mapping(address => bool) public responders;

    struct Response {
        uint256 id;
        string incidentDescription;
        uint256 timestamp;
        address[] assignedResponders;
        bool resolved;
    }

    uint256 public nextResponseId;
    mapping(uint256 => Response) public responses;

    event ResponderAdded(address indexed responder);
    event ResponderRemoved(address indexed responder);
    event ResponseTriggered(uint256 indexed id, string incidentDescription, address[] responders);
    event ResponseResolved(uint256 indexed id, address indexed resolver);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyResponder() {
        require(responders[msg.sender], "Not responder");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Governance: add/remove responders
    function addResponder(address responder) external onlyOwner {
        responders[responder] = true;
        emit ResponderAdded(responder);
    }

    function removeResponder(address responder) external onlyOwner {
        responders[responder] = false;
        emit ResponderRemoved(responder);
    }

    // Trigger response
    function triggerResponse(string calldata incidentDescription, address[] calldata assigned) external onlyOwner {
        responses[nextResponseId] = Response({
            id: nextResponseId,
            incidentDescription: incidentDescription,
            timestamp: block.timestamp,
            assignedResponders: assigned,
            resolved: false
        });
        emit ResponseTriggered(nextResponseId, incidentDescription, assigned);
        nextResponseId++;
    }

    // Resolve response
    function resolveResponse(uint256 id) external onlyResponder {
        require(!responses[id].resolved, "Already resolved");
        responses[id].resolved = true;
        emit ResponseResolved(id, msg.sender);
    }

    // Owner override: force resolve
    function forceResolve(uint256 id) external onlyOwner {
        responses[id].resolved = true;
        emit ResponseResolved(id, msg.sender);
    }
}
