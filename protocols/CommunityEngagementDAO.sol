// CommunityEngagementDAO.sol
pragma solidity ^0.8.0;

contract CommunityEngagementDAO {
    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 rewardPool;
        uint256 timestamp;
        bool executed;
    }

    uint256 public eventCount;
    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => bool)) public hasJoined;

    event EventCreated(uint256 id, string name, string description, uint256 rewardPool, uint256 timestamp);
    event EventJoined(address indexed participant, uint256 eventId);
    event EventExecuted(uint256 id, string name);
    event EngagementDeclared(string message);

    function createEvent(string memory name, string memory description, uint256 rewardPool) public {
        eventCount++;
        events[eventCount] = Event(eventCount, name, description, rewardPool, block.timestamp, false);
        emit EventCreated(eventCount, name, description, rewardPool, block.timestamp);
    }

    function joinEvent(uint256 eventId) public {
        require(!hasJoined[msg.sender][eventId], "Already joined");
        hasJoined[msg.sender][eventId] = true;
        emit EventJoined(msg.sender, eventId);
    }

    function executeEvent(uint256 eventId) public {
        Event storage e = events[eventId];
        require(!e.executed, "Already executed");
        e.executed = true;
        emit EventExecuted(e.id, e.name);
    }

    function declareEngagement() public {
        emit EngagementDeclared("Community Engagement DAO: collective events and rewards igniting crypto activity.");
    }
}
