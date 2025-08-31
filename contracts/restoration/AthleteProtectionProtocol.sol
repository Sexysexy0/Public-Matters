// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AthleteProtectionProtocol {
    address public mythicValidator;

    struct Athlete {
        address steward;
        string sport;
        string barangay;
        uint256 emotionalAPR;
        bool medicalGuardianAssigned;
        bool clearedToCompete;
    }

    mapping(address => Athlete) public athletes;
    mapping(address => bool) public certifiedMedicalGuardians;

    event AthleteRegistered(address indexed steward, string sport, string barangay, uint256 emotionalAPR);
    event GuardianCertified(address indexed guardian);
    event GuardianAssigned(address indexed steward, address guardian);
    event ClearanceGranted(address indexed steward, bool status);
    event EmergencyTriggered(address indexed steward, string reason);
    event BroadcastInvoked(string message);

    modifier onlyValidator() {
        require(msg.sender == mythicValidator, "Not authorized");
        _;
    }

    constructor() {
        mythicValidator = msg.sender;
    }

    function registerAthlete(
        address _steward,
        string memory _sport,
        string memory _barangay,
        uint256 _emotionalAPR
    ) public onlyValidator {
        athletes[_steward] = Athlete(_steward, _sport, _barangay, _emotionalAPR, false, false);
        emit AthleteRegistered(_steward, _sport, _barangay, _emotionalAPR);
        if (_emotionalAPR >= 90) {
            autoTriggerMedical(_steward);
        }
    }

    function certifyGuardian(address _guardian) public onlyValidator {
        certifiedMedicalGuardians[_guardian] = true;
        emit GuardianCertified(_guardian);
    }

    function assignGuardian(address _steward, address _guardian) public onlyValidator {
        require(certifiedMedicalGuardians[_guardian], "Guardian not certified");
        athletes[_steward].medicalGuardianAssigned = true;
        emit GuardianAssigned(_steward, _guardian);
    }

    function grantClearance(address _steward, bool _status) public onlyValidator {
        require(athletes[_steward].medicalGuardianAssigned, "No guardian assigned");
        athletes[_steward].clearedToCompete = _status;
        emit ClearanceGranted(_steward, _status);
    }

    function autoTriggerMedical(address _steward) internal {
        if (athletes[_steward].emotionalAPR >= 90 && athletes[_steward].medicalGuardianAssigned) {
            emit EmergencyTriggered(_steward, "High emotional APR detected – medical standby activated");
            invokeBroadcast("Emergency standby activated for athlete: high APR detected");
        }
    }

    function invokeBroadcast(string memory _message) public onlyValidator {
        emit BroadcastInvoked(_message);
    }
}
