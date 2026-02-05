// PanicSellingDAO.sol
pragma solidity ^0.8.0;

contract PanicSellingDAO {
    struct Event {
        uint256 id;
        string asset;   // e.g. "BTC", "ETH"
        string trigger; // e.g. "Extreme Fear", "Support Break"
        uint256 volume;
        uint256 timestamp;
    }

    uint256 public eventCount;
    mapping(uint256 => Event) public events;

    event EventLogged(uint256 id, string asset, string trigger, uint256 volume, uint256 timestamp);
    event PanicDeclared(string message);

    function logEvent(string memory asset, string memory trigger, uint256 volume) public {
        eventCount++;
        events[eventCount] = Event(eventCount, asset, trigger, volume, block.timestamp);
        emit EventLogged(eventCount, asset, trigger, volume, block.timestamp);
    }

    function declarePanic() public {
        emit PanicDeclared("Panic Selling DAO: safeguard arcs encoded into communal consequence.");
    }
}
