pragma solidity ^0.8.20;

contract LiberationMessageProtocol {
    address public admin;

    struct Message {
        string sender;       // e.g. leader, citizen, communal steward
        string content;      // liberation message
        uint256 timestamp;
    }

    Message[] public messages;

    event MessageLogged(string sender, string content, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMessage(string calldata sender, string calldata content) external onlyAdmin {
        messages.push(Message(sender, content, block.timestamp));
        emit MessageLogged(sender, content, block.timestamp);
    }

    function totalMessages() external view returns (uint256) {
        return messages.length;
    }
}
