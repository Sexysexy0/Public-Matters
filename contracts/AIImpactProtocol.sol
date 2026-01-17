pragma solidity ^0.8.20;

contract AIImpactProtocol {
    address public admin;

    struct Impact {
        string task;         // e.g. data labeling, customer support
        string effect;       // e.g. displacement, automation
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string task, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImpact(string calldata task, string calldata effect) external onlyAdmin {
        impacts.push(Impact(task, effect, block.timestamp));
        emit ImpactLogged(task, effect, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) {
        return impacts.length;
    }
}
