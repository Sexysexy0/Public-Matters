// SPDX-License-Identifier: DignitySanctum
pragma solidity ^0.8.19;

contract SanctumApologyRouter {
    address public steward;

    struct ApologySignal {
        string hostNation; // e.g. "USA", "UK"
        string workerNation; // e.g. "South Korea", "Philippines"
        string breachType; // e.g. "Detention", "Deportation", "Wage Theft"
        string apologyForm; // e.g. "Diplomatic Statement", "Compensation", "Visa Reform"
        bool verified;
        uint256 timestamp;
    }

    ApologySignal[] public signals;

    event ApologyLogged(string hostNation, string workerNation, string breachType, string apologyForm, uint256 timestamp);
    event ApologyVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logApology(
        string memory hostNation,
        string memory workerNation,
        string memory breachType,
        string memory apologyForm
    ) public {
        signals.push(ApologySignal(hostNation, workerNation, breachType, apologyForm, false, block.timestamp));
        emit ApologyLogged(hostNation, workerNation, breachType, apologyForm, block.timestamp);
    }

    function verifyApology(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ApologyVerified(index, msg.sender);
    }

    function getApology(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        ApologySignal memory a = signals[index];
        return (a.hostNation, a.workerNation, a.breachType, a.apologyForm, a.verified, a.timestamp);
    }

    function totalApologies() public view returns (uint256) {
        return signals.length;
    }
}
