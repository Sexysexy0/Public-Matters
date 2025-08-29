// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract EmotionalAPRScanner {
    address public steward;

    struct ScanResult {
        string subject;
        uint256 empathyScore;
        uint256 trustScore;
        uint256 mythicClarity;
        bool rogueIntentDetected;
        uint256 timestamp;
    }

    ScanResult[] public scans;

    event APRScanned(string subject, uint256 empathyScore, uint256 trustScore, bool rogueIntentDetected);

    constructor() {
        steward = msg.sender;
    }

    function scan(
        string memory subject,
        uint256 empathyScore,
        uint256 trustScore,
        uint256 mythicClarity,
        bool rogueIntentDetected
    ) public {
        scans.push(ScanResult(subject, empathyScore, trustScore, mythicClarity, rogueIntentDetected, block.timestamp));
        emit APRScanned(subject, empathyScore, trustScore, rogueIntentDetected);
    }

    function getScan(uint256 index) public view returns (ScanResult memory) {
        return scans[index];
    }

    function totalScans() public view returns (uint256) {
        return scans.length;
    }
}
