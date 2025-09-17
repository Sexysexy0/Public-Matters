// SPDX-License-Identifier: TruthSanctum
pragma solidity ^0.8.19;

contract DisinfoContainmentRouter {
    address public steward;

    struct DisinfoSignal {
        string sourceTag; // e.g. "Synthetic Broadcast", "Compromised Feed", "Foreign Influence"
        string contentHash;
        string threatLevel; // e.g. "Low", "Moderate", "Critical"
        bool contained;
        uint256 timestamp;
    }

    DisinfoSignal[] public signals;

    event DisinfoLogged(string sourceTag, string contentHash, string threatLevel, uint256 timestamp);
    event DisinfoContained(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDisinfo(
        string memory sourceTag,
        string memory contentHash,
        string memory threatLevel
    ) public {
        signals.push(DisinfoSignal(sourceTag, contentHash, threatLevel, false, block.timestamp));
        emit DisinfoLogged(sourceTag, contentHash, threatLevel, block.timestamp);
    }

    function containDisinfo(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].contained = true;
        emit DisinfoContained(index, msg.sender);
    }

    function getDisinfo(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        DisinfoSignal memory d = signals[index];
        return (d.sourceTag, d.contentHash, d.threatLevel, d.contained, d.timestamp);
    }

    function totalDisinfoSignals() public view returns (uint256) {
        return signals.length;
    }
}
