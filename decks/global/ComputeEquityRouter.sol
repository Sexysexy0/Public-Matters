// SPDX-License-Identifier: ComputeEquity
pragma solidity ^0.8.19;

contract ComputeEquityRouter {
    address public steward;

    struct EquitySignal {
        string nationOrCompany; // e.g. "China", "ByteDance", "Alibaba"
        string equityType; // "Chip Access", "AI Sovereignty", "Corridor Blessing"
        string protocolTag; // e.g. "Equity #CE7", "Signal #AI3"
        bool verified;
        uint256 timestamp;
    }

    EquitySignal[] public signals;

    event EquityLogged(string nationOrCompany, string equityType, string protocolTag, uint256 timestamp);
    event EquityVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logEquity(
        string memory nationOrCompany,
        string memory equityType,
        string memory protocolTag
    ) public {
        signals.push(EquitySignal(nationOrCompany, equityType, protocolTag, false, block.timestamp));
        emit EquityLogged(nationOrCompany, equityType, protocolTag, block.timestamp);
    }

    function verifyEquity(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit EquityVerified(index, msg.sender);
    }

    function getEquity(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        EquitySignal memory e = signals[index];
        return (e.nationOrCompany, e.equityType, e.protocolTag, e.verified, e.timestamp);
    }

    function totalEquitySignals() public view returns (uint256) {
        return signals.length;
    }
}
