// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PerceptionMirror {
    address public overseer;
    uint256 public messageCount;

    struct Message {
        uint256 id;
        string theme;
        string content;
        uint256 timestamp;
    }

    mapping(uint256 => Message) public messages;
    event NarrativeDeclared(uint256 indexed id, string theme, string content);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareNarrative(string calldata theme, string calldata content) external onlyOverseer {
        messageCount++;
        messages[messageCount] = Message(messageCount, theme, content, block.timestamp);
        emit NarrativeDeclared(messageCount, theme, content);
    }
}
