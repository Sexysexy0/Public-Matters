pragma solidity ^0.8.20;

contract SelfCareProtocol {
    address public admin;

    struct Practice {
        string focus;        // e.g. self-care, service, contribution
        string effect;       // e.g. weakness, fulfillment, pull motivation
        uint256 timestamp;
    }

    Practice[] public practices;

    event PracticeLogged(string focus, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPractice(string calldata focus, string calldata effect) external onlyAdmin {
        practices.push(Practice(focus, effect, block.timestamp));
        emit PracticeLogged(focus, effect, block.timestamp);
    }

    function totalPractices() external view returns (uint256) {
        return practices.length;
    }
}
