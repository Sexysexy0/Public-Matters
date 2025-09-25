// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BipartisanDialogueActivationProtocol
/// @notice Ritualizes bipartisan negotiation and honors Democratic demands for governance restoration
/// @dev Anchors emotional consequence, override removal, and legislative trust

contract BipartisanDialogueActivationProtocol {
    address public steward;
    mapping(address => bool) public mediators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyMediator() {
        require(mediators[msg.sender] || msg.sender == steward, "Not mediator");
        _;
    }

    struct DialogueEvent {
        uint256 id;
        string corridor; // e.g., "Budget", "Shutdown", "Healthcare", "Transparency"
        string partyRequest; // e.g., "Democrats request full budget disclosure"
        bool overrideRemoved;
        bool negotiationActivated;
        string emotionalTag; // e.g., "Governance dignity restored"
        string restorationClause; // e.g., "We commit to bipartisan cooperation and mutual respect"
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => DialogueEvent) public events;

    event MediatorSet(address indexed account, bool status);
    event DialogueActivated(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        mediators[msg.sender] = true;
        emit MediatorSet(msg.sender, true);
    }

    function setMediator(address account, bool status) external onlySteward {
        mediators[account] = status;
        emit MediatorSet(account, status);
    }

    function activateDialogue(
        string calldata corridor,
        string calldata partyRequest,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyMediator returns (uint256 id) {
        id = nextEventId++;
        events[id] = DialogueEvent({
            id: id,
            corridor: corridor,
            partyRequest: partyRequest,
            overrideRemoved: true,
            negotiationActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit DialogueActivated(id, corridor, emotionalTag);
    }

    function getDialogue(uint256 id) external view returns (DialogueEvent memory) {
        return events[id];
    }
}
