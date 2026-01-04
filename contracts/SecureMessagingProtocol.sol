pragma solidity ^0.8.20;

contract SecureMessagingProtocol {
    address public admin;

    struct Message {
        string platform;     // e.g. Signal, Teams, WhatsApp
        string status;       // e.g. encrypted, intercepted, compromised
        uint256 timestamp;
    }

    Message[] public messages;

    event MessageLogged(string platform, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMessage(string calldata platform, string calldata status) external onlyAdmin {
        messages.push(Message(platform, status, block.timestamp));
        emit MessageLogged(platform, status, block.timestamp);
    }

    function totalMessages() external view returns (uint256) {
        return messages.length;
    }
}
