pragma solidity ^0.8.20;

contract EconomicImpactProtocol {
    address public admin;

    struct Impact {
        string sector;       // e.g. households, banks
        string shortTerm;    // e.g. debt relief, consumption boost
        string longTerm;     // e.g. credit contraction, liquidity gaps
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string sector, string shortTerm, string longTerm, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImpact(string calldata sector, string calldata shortTerm, string calldata longTerm) external onlyAdmin {
        impacts.push(Impact(sector, shortTerm, longTerm, block.timestamp));
        emit ImpactLogged(sector, shortTerm, longTerm, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) {
        return impacts.length;
    }
}
