// SPDX-License-Identifier: PayloadSanctum
pragma solidity ^0.8.19;

contract SteganographyPayloadScanner {
    address public steward;

    struct PayloadScan {
        string imageHash;
        string sourceURL;
        string malwareType; // e.g. "StealC", "GoLoader"
        bool detected;
        uint256 timestamp;
    }

    PayloadScan[] public scans;

    event PayloadLogged(string imageHash, string sourceURL, string malwareType, uint256 timestamp);
    event PayloadDetected(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPayload(
        string memory imageHash,
        string memory sourceURL,
        string memory malwareType
    ) public {
        scans.push(PayloadScan(imageHash, sourceURL, malwareType, false, block.timestamp));
        emit PayloadLogged(imageHash, sourceURL, malwareType, block.timestamp);
    }

    function detectPayload(uint256 index) public {
        require(index < scans.length, "Invalid index");
        scans[index].detected = true;
        emit PayloadDetected(index, msg.sender);
    }

    function getPayload(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        PayloadScan memory p = scans[index];
        return (p.imageHash, p.sourceURL, p.malwareType, p.detected, p.timestamp);
    }

    function totalScans() public view returns (uint256) {
        return scans.length;
    }
}
