pragma solidity ^0.8.20;

contract SolidarityNetworkProtocol {
    address public admin;

    struct Network {
        string group;        // e.g. unions, faith groups, city councils
        string action;       // e.g. strike support, protest organization
        string impact;       // e.g. shutdown scale, community defense
        uint256 timestamp;
    }

    Network[] public networks;

    event NetworkLogged(string group, string action, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logNetwork(string calldata group, string calldata action, string calldata impact) external onlyAdmin {
        networks.push(Network(group, action, impact, block.timestamp));
        emit NetworkLogged(group, action, impact, block.timestamp);
    }

    function totalNetworks() external view returns (uint256) {
        return networks.length;
    }
}
