// SPDX-License-Identifier: ClipboardSanctum
pragma solidity ^0.8.19;

contract ClipboardTrustRouter {
    address public steward;

    struct ClipboardEvent {
        string user;
        string destination; // e.g. "Run Dialog", "Terminal", "File Explorer"
        string clipboardContent;
        string sourceURL;
        bool trusted;
        uint256 timestamp;
    }

    ClipboardEvent[] public events;

    event ClipboardLogged(string user, string destination, string clipboardContent, string sourceURL, uint256 timestamp);
    event ClipboardVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logClipboard(
        string memory user,
        string memory destination,
        string memory clipboardContent,
        string memory sourceURL
    ) public {
        events.push(ClipboardEvent(user, destination, clipboardContent, sourceURL, false, block.timestamp));
        emit ClipboardLogged(user, destination, clipboardContent, sourceURL, block.timestamp);
    }

    function verifyClipboard(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].trusted = true;
        emit ClipboardVerified(index, msg.sender);
    }

    function getClipboard(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        ClipboardEvent memory e = events[index];
        return (e.user, e.destination, e.clipboardContent, e.sourceURL, e.trusted, e.timestamp);
    }

    function totalClipboardEvents() public view returns (uint256) {
        return events.length;
    }
}
