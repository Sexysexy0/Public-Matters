pragma solidity ^0.8.20;

contract LegacyAutomakerProtocol {
    address public admin;

    struct Automaker {
        string name;         // e.g. VW, Toyota, Stellantis
        string focus;        // e.g. hybrids, EV rollout
        string impact;       // e.g. market dominance, transition pacing
        uint256 timestamp;
    }

    Automaker[] public automakers;

    event AutomakerLogged(string name, string focus, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAutomaker(string calldata name, string calldata focus, string calldata impact) external onlyAdmin {
        automakers.push(Automaker(name, focus, impact, block.timestamp));
        emit AutomakerLogged(name, focus, impact, block.timestamp);
    }

    function totalAutomakers() external view returns (uint256) {
        return automakers.length;
    }
}
