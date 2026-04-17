// UniversalCitizenLedger.sol
pragma solidity ^0.8.0;

contract UniversalCitizenLedger {
    struct CitizenRights {
        bool accessToHealthcare;
        bool accessToEducation;
        uint256 socialCreditScore; // Base on civic contribution, not obedience
    }

    mapping(address => CitizenRights) public globalRights;

    function verifyServiceAccess(address _citizen) public view returns (bool) {
        // Rights are portable and independent of geographic registration
        return globalRights[_citizen].accessToHealthcare;
    }
}
