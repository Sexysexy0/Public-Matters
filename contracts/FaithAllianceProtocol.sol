pragma solidity ^0.8.20;

contract FaithAllianceProtocol {
    address public admin;

    struct Alliance {
        string group;        // e.g. church, mosque, synagogue
        string support;      // e.g. moral backing, shelter, food aid
        string effect;       // e.g. community morale, protest strength
        uint256 timestamp;
    }

    Alliance[] public alliances;

    event AllianceLogged(string group, string support, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAlliance(string calldata group, string calldata support, string calldata effect) external onlyAdmin {
        alliances.push(Alliance(group, support, effect, block.timestamp));
        emit AllianceLogged(group, support, effect, block.timestamp);
    }

    function totalAlliances() external view returns (uint256) {
        return alliances.length;
    }
}
