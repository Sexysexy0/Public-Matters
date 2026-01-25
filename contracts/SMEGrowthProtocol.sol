pragma solidity ^0.8.20;

contract SMEGrowthProtocol {
    address public admin;

    struct Enterprise {
        string name;         // e.g. BlackRock, Anthropic, OpenAI
        string origin;       // e.g. small enterprise, startup
        string trajectory;   // e.g. global leader, innovation driver
        uint256 timestamp;
    }

    Enterprise[] public enterprises;

    event EnterpriseLogged(string name, string origin, string trajectory, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEnterprise(string calldata name, string calldata origin, string calldata trajectory) external onlyAdmin {
        enterprises.push(Enterprise(name, origin, trajectory, block.timestamp));
        emit EnterpriseLogged(name, origin, trajectory, block.timestamp);
    }

    function totalEnterprises() external view returns (uint256) {
        return enterprises.length;
    }
}
