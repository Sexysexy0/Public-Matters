pragma solidity ^0.8.20;

contract AviationGrowthProtocol {
    address public admin;

    struct Growth {
        string driver;       // e.g. connectivity, infrastructure, long-haul routes
        string impact;       // e.g. GDP growth, jobs, poverty reduction
        uint256 timestamp;
    }

    Growth[] public growths;

    event GrowthLogged(string driver, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGrowth(string calldata driver, string calldata impact) external onlyAdmin {
        growths.push(Growth(driver, impact, block.timestamp));
        emit GrowthLogged(driver, impact, block.timestamp);
    }

    function totalGrowths() external view returns (uint256) {
        return growths.length;
    }
}
