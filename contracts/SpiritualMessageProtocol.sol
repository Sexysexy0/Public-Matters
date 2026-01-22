pragma solidity ^0.8.20;

contract SpiritualMessageProtocol {
    address public admin;

    struct Message {
        string teaching;     // e.g. Render unto Caesar
        string theme;        // e.g. spiritual vs political authority
        string effect;       // e.g. deeper reflection, moral clarity
        uint256 timestamp;
    }

    Message[] public messages;

    event MessageLogged(string teaching, string theme, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMessage(string calldata teaching, string calldata theme, string calldata effect) external onlyAdmin {
        messages.push(Message(teaching, theme, effect, block.timestamp));
        emit MessageLogged(teaching, theme, effect, block.timestamp);
    }

    function totalMessages() external view returns (uint256) {
        return messages.length;
    }
}
