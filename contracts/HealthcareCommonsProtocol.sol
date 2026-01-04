pragma solidity ^0.8.20;

contract HealthcareCommonsProtocol {
    address public admin;

    struct Coverage {
        string beneficiary;   // e.g. worker, freelancer, comedian
        string service;       // e.g. hospitalization, medicine, checkups
        uint256 timestamp;
    }

    Coverage[] public coverages;

    event CoverageLogged(string beneficiary, string service, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCoverage(string calldata beneficiary, string calldata service) external onlyAdmin {
        coverages.push(Coverage(beneficiary, service, block.timestamp));
        emit CoverageLogged(beneficiary, service, block.timestamp);
    }

    function totalCoverages() external view returns (uint256) {
        return coverages.length;
    }
}
