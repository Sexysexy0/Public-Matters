// SPDX-License-Identifier: FedStewardship
pragma solidity ^0.8.19;

contract RateCutClarifier {
    address public steward;

    struct RateCutSignal {
        uint256 basisPoints;
        string rationale; // e.g. "Labor Weakness", "Inflation Control", "Political Pressure"
        string source; // e.g. "FOMC Minutes", "Powell Briefing"
        bool verified;
        uint256 timestamp;
    }

    RateCutSignal[] public signals;

    event RateCutLogged(uint256 basisPoints, string rationale, string source, uint256 timestamp);
    event RateCutVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logRateCut(
        uint256 basisPoints,
        string memory rationale,
        string memory source
    ) public {
        signals.push(RateCutSignal(basisPoints, rationale, source, false, block.timestamp));
        emit RateCutLogged(basisPoints, rationale, source, block.timestamp);
    }

    function verifyRateCut(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit RateCutVerified(index, msg.sender);
    }

    function getRateCut(uint256 index) public view returns (
        uint256, string memory, string memory, bool, uint256
    ) {
        RateCutSignal memory r = signals[index];
        return (r.basisPoints, r.rationale, r.source, r.verified, r.timestamp);
    }

    function totalRateCuts() public view returns (uint256) {
        return signals.length;
    }
}
