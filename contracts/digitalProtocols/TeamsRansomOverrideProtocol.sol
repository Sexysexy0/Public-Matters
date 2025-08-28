// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TeamsRansomOverrideProtocol {
    struct Message {
        address sender;
        string content;
        bool isRansom;
    }

    Message[] public messages;

    event RansomAttemptBlocked(address sender, string content);

    function sendMessage(string memory content) public {
        bool ransomDetected = bytes(content).length > 0 && (contains(content, "ransom") || contains(content, "payment"));
        messages.push(Message(msg.sender, content, ransomDetected));
        if (ransomDetected) emit RansomAttemptBlocked(msg.sender, content);
    }

    function contains(string memory haystack, string memory needle) internal pure returns (bool) {
        return bytes(haystack).length >= bytes(needle).length && keccak256(bytes(haystack)) == keccak256(bytes(needle));
    }
}
