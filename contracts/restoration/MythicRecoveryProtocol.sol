pragma solidity ^0.8.19;

contract MythicRecoveryProtocol {
    address public mythicValidator;

    struct Recovery {
        address steward;
        uint256 cooldownScore;
        bool guardianCheckIn;
        string ritualAssigned;
        uint256 timestamp;
    }

    mapping(address => Recovery[]) public recoveryLogs;

    event RecoveryLogged(address indexed steward, uint256 cooldownScore, string ritualAssigned, uint256 timestamp);

    modifier onlyValidator() {
        require(msg.sender == mythicValidator, "Not authorized");
        _;
    }

    constructor() {
        mythicValidator = msg.sender;
    }

    function logRecovery(address _steward, uint256 _cooldownScore, string memory _ritualAssigned) public onlyValidator {
        recoveryLogs[_steward].push(Recovery(_steward, _cooldownScore, true, _ritualAssigned, block.timestamp));
        emit RecoveryLogged(_steward, _cooldownScore, _ritualAssigned, block.timestamp);
    }
}
