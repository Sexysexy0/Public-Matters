// NormalizationResistanceProtocol.sol
pragma solidity ^0.8.0;

contract NormalizationResistanceProtocol {
    struct Event {
        uint256 id;
        string ritual;     // e.g. "Public Ceremony"
        string exposure;   // e.g. "Occult symbolism"
        string resistance; // e.g. "Guardian vigilance activated"
        uint256 timestamp;
    }

    uint256 public eventCount;
    mapping(uint256 => Event) public events;

    event EventLogged(uint256 id, string ritual, string exposure, string resistance);

    function logEvent(string memory ritual, string memory exposure, string memory resistance) public {
        eventCount++;
        events[eventCount] = Event(eventCount, ritual, exposure, resistance, block.timestamp);
        emit EventLogged(eventCount, ritual, exposure, resistance);
    }
}
