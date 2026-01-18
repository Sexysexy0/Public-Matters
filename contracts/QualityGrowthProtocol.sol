pragma solidity ^0.8.20;

contract QualityGrowthProtocol {
    address public admin;

    struct Growth {
        string driver;       // e.g. industrial policy, manufacturing jobs
        string benefit;      // e.g. sustainable employment, higher GDP, resilience
        uint256 timestamp;
    }

    Growth[] public growths;

    event GrowthLogged(string driver, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGrowth(string calldata driver, string calldata benefit) external onlyAdmin {
        growths.push(Growth(driver, benefit, block.timestamp));
        emit GrowthLogged(driver, benefit, block.timestamp);
    }

    function totalGrowths() external view returns (uint256) {
        return growths.length;
    }
}
