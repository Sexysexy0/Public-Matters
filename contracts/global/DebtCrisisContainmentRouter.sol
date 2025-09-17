// SPDX-License-Identifier: DebtSanctum
pragma solidity ^0.8.19;

contract DebtCrisisContainmentRouter {
    address public steward;

    struct DebtSignal {
        string nationTag; // e.g. "USA", "UK", "Japan"
        uint256 debtToGDP;
        string riskSignal; // e.g. "Unsustainable", "Crisis Threshold", "Contained"
        bool verified;
        uint256 timestamp;
    }

    DebtSignal[] public signals;

    event DebtLogged(string nationTag, uint256 debtToGDP, string riskSignal, uint256 timestamp);
    event DebtVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDebt(
        string memory nationTag,
        uint256 debtToGDP,
        string memory riskSignal
    ) public {
        signals.push(DebtSignal(nationTag, debtToGDP, riskSignal, false, block.timestamp));
        emit DebtLogged(nationTag, debtToGDP, riskSignal, block.timestamp);
    }

    function verifyDebt(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit DebtVerified(index, msg.sender);
    }

    function getDebt(uint256 index) public view returns (
        string memory, uint256, string memory, bool, uint256
    ) {
        DebtSignal memory d = signals[index];
        return (d.nationTag, d.debtToGDP, d.riskSignal, d.verified, d.timestamp);
    }

    function totalDebtSignals() public view returns (uint256) {
        return signals.length;
    }
}
