pragma solidity ^0.8.19;

contract EmotionalTelemetryFeed {
    address public mythicValidator;

    struct Telemetry {
        uint256 heartRate;
        uint256 stressLevel;
        uint256 emotionalAPR;
        uint256 timestamp;
    }

    mapping(address => Telemetry[]) public athleteTelemetry;

    event TelemetryLogged(address indexed steward, uint256 heartRate, uint256 stressLevel, uint256 emotionalAPR, uint256 timestamp);

    modifier onlyValidator() {
        require(msg.sender == mythicValidator, "Not authorized");
        _;
    }

    constructor() {
        mythicValidator = msg.sender;
    }

    function logTelemetry(address _steward, uint256 _heartRate, uint256 _stressLevel, uint256 _emotionalAPR) public onlyValidator {
        athleteTelemetry[_steward].push(Telemetry(_heartRate, _stressLevel, _emotionalAPR, block.timestamp));
        emit TelemetryLogged(_steward, _heartRate, _stressLevel, _emotionalAPR, block.timestamp);
    }
}
