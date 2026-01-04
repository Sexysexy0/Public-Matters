pragma solidity ^0.8.20;

contract UserAwarenessCommonsProtocol {
    address public admin;

    struct Training {
        string topic;        // e.g. phishing, extension risks
        string status;       // e.g. completed, pending
        uint256 timestamp;
    }

    Training[] public trainings;

    event TrainingLogged(string topic, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logTraining(string calldata topic, string calldata status) external onlyAdmin {
        trainings.push(Training(topic, status, block.timestamp));
        emit TrainingLogged(topic, status, block.timestamp);
    }

    function totalTrainings() external view returns (uint256) {
        return trainings.length;
    }
}
