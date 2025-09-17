// SPDX-License-Identifier: PayloadSanctum
pragma solidity ^0.8.19;

contract PayloadObfuscationScanner {
    address public steward;

    struct ObfuscationEvent {
        string payloadSample;
        string obfuscationType; // e.g. "Base64", "Whitespace", "Comment Injection"
        string sourceTag; // e.g. "Image", "Script", "Clipboard"
        bool detected;
        uint256 timestamp;
    }

    ObfuscationEvent[] public events;

    event ObfuscationLogged(string payloadSample, string obfuscationType, string sourceTag, uint256 timestamp);
    event ObfuscationDetected(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logObfuscation(
        string memory payloadSample,
        string memory obfuscationType,
        string memory sourceTag
    ) public {
        events.push(ObfuscationEvent(payloadSample, obfuscationType, sourceTag, false, block.timestamp));
        emit ObfuscationLogged(payloadSample, obfuscationType, sourceTag, block.timestamp);
    }

    function detectObfuscation(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].detected = true;
        emit ObfuscationDetected(index, msg.sender);
    }

    function getObfuscation(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        ObfuscationEvent memory e = events[index];
        return (e.payloadSample, e.obfuscationType, e.sourceTag, e.detected, e.timestamp);
    }

    function totalObfuscations() public view returns (uint256) {
        return events.length;
    }
}
