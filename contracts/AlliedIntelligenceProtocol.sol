pragma solidity ^0.8.20;

contract AlliedIntelligenceProtocol {
    address public admin;

    struct Alliance {
        string ally;         // e.g. UK, Israel, Japan
        string contribution; // e.g. intelligence brief, surveillance data
        string effect;       // e.g. supplement CIA gaps, strengthen trust
        uint256 timestamp;
    }

    Alliance[] public alliances;

    event AllianceLogged(string ally, string contribution, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAlliance(string calldata ally, string calldata contribution, string calldata effect) external onlyAdmin {
        alliances.push(Alliance(ally, contribution, effect, block.timestamp));
        emit AllianceLogged(ally, contribution, effect, block.timestamp);
    }

    function totalAlliances() external view returns (uint256) {
        return alliances.length;
    }
}
