// SPDX-License-Identifier: FixSanctum
pragma solidity ^0.8.19;

contract FixAttackDetector {
    address public steward;

    struct InjectionEvent {
        string user;
        string dialogType; // e.g. "Run", "Terminal", "File Explorer"
        string payloadSample;
        string sourceURL;
        bool verified;
        uint256 timestamp;
    }

    InjectionEvent[] public events;

    event InjectionLogged(string user, string dialogType, string payloadSample, string sourceURL, uint256 timestamp);
    event InjectionVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logInjection(
        string memory user,
        string memory dialogType,
        string memory payloadSample,
        string memory sourceURL
    ) public {
        events.push(InjectionEvent(user, dialogType, payloadSample, sourceURL, false, block.timestamp));
        emit InjectionLogged(user, dialogType, payloadSample, sourceURL, block.timestamp);
    }

    function verifyInjection(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit InjectionVerified(index, msg.sender);
    }

    function getInjection(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        InjectionEvent memory e = events[index];
        return (e.user, e.dialogType, e.payloadSample, e.sourceURL, e.verified, e.timestamp);
    }

    function totalInjections() public view returns (uint256) {
        return events.length;
    }
}
