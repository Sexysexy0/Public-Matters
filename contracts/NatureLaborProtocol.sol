pragma solidity ^0.8.20;

contract NatureLaborProtocol {
    address public admin;

    struct Sign {
        string event;        // e.g. earthquake, famine, cosmic storm
        string meaning;      // e.g. sign of kingdom, intensifying labor pains
        uint256 timestamp;
    }

    Sign[] public signs;

    event SignLogged(string event, string meaning, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSign(string calldata event, string calldata meaning) external onlyAdmin {
        signs.push(Sign(event, meaning, block.timestamp));
        emit SignLogged(event, meaning, block.timestamp);
    }

    function totalSigns() external view returns (uint256) {
        return signs.length;
    }
}
