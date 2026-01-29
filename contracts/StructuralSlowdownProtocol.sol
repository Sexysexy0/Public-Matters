pragma solidity ^0.8.20;

contract StructuralSlowdownProtocol {
    address public admin;

    struct Slowdown {
        string sector;       // e.g. MSMEs, Agriculture, Industry
        string cause;        // e.g. Inflation, Import dependence
        uint256 timestamp;
    }

    Slowdown[] public slowdowns;

    event SlowdownLogged(string sector, string cause, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSlowdown(string calldata sector, string calldata cause) external onlyAdmin {
        slowdowns.push(Slowdown(sector, cause, block.timestamp));
        emit SlowdownLogged(sector, cause, block.timestamp);
    }

    function totalSlowdowns() external view returns (uint256) {
        return slowdowns.length;
    }
}
