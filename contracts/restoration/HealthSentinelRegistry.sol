pragma solidity ^0.8.19;

contract HealthSentinelRegistry {
    address public mythicValidator;

    struct Guardian {
        address steward;
        string specialization;
        bool certified;
    }

    mapping(address => Guardian) public guardians;

    event GuardianCertified(address indexed steward, string specialization);
    event GuardianRevoked(address indexed steward);

    modifier onlyValidator() {
        require(msg.sender == mythicValidator, "Not authorized");
        _;
    }

    constructor() {
        mythicValidator = msg.sender;
    }

    function certifyGuardian(address _steward, string memory _specialization) public onlyValidator {
        guardians[_steward] = Guardian(_steward, _specialization, true);
        emit GuardianCertified(_steward, _specialization);
    }

    function revokeGuardian(address _steward) public onlyValidator {
        guardians[_steward].certified = false;
        emit GuardianRevoked(_steward);
    }
}
