// contracts/UniversalInsurance.sol
pragma solidity ^0.8.20;

/**
 * @title UniversalInsurance
 * @notice Logs universal health insurance coverage for all persons.
 */
contract UniversalInsurance {
    address public admin;

    struct Policy {
        string beneficiary; // "Worker", "Freelancer", "Comedian"
        string coverage;    // "Hospitalization", "PreventiveCare", "Emergency"
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string beneficiary, string coverage, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logPolicy(string calldata beneficiary, string calldata coverage) external onlyAdmin {
        policies.push(Policy(beneficiary, coverage, block.timestamp));
        emit PolicyLogged(beneficiary, coverage, block.timestamp);
    }
}
