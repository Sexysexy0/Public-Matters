pragma solidity ^0.8.20;

contract LogisticsEfficiencyProtocol {
    address public admin;

    struct Efficiency {
        string sector;       // e.g. trucking, shipping
        string driver;       // e.g. lower diesel cost
        string outcome;      // e.g. faster, cheaper delivery
        uint256 timestamp;
    }

    Efficiency[] public efficiencies;

    event EfficiencyLogged(string sector, string driver, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEfficiency(string calldata sector, string calldata driver, string calldata outcome) external onlyAdmin {
        efficiencies.push(Efficiency(sector, driver, outcome, block.timestamp));
        emit EfficiencyLogged(sector, driver, outcome, block.timestamp);
    }

    function totalEfficiencies() external view returns (uint256) {
        return efficiencies.length;
    }
}
