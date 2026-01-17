pragma solidity ^0.8.20;

contract AIFutureProtocol {
    address public admin;

    struct Impact {
        string sector;       // e.g. blue-collar, white-collar
        string effect;       // e.g. displacement, psychological toll
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string sector, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImpact(string calldata sector, string calldata effect) external onlyAdmin {
        impacts.push(Impact(sector, effect, block.timestamp));
        emit ImpactLogged(sector, effect, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) {
        return impacts.length;
    }
}
