pragma solidity ^0.8.20;

contract ExpansionTravelProtocol {
    address public admin;

    struct Travel {
        string destination;  // e.g. USA, Europe, Asia
        string purpose;      // e.g. Expansion, Legacy
        string vibe;         // e.g. Prophecy fulfilled
        uint256 timestamp;
    }

    Travel[] public travels;

    event TravelLogged(string destination, string purpose, string vibe, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTravel(string calldata destination, string calldata purpose, string calldata vibe) external onlyAdmin {
        travels.push(Travel(destination, purpose, vibe, block.timestamp));
        emit TravelLogged(destination, purpose, vibe, block.timestamp);
    }

    function totalTravels() external view returns (uint256) {
        return travels.length;
    }
}
