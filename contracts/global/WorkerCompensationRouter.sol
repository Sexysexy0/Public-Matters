// SPDX-License-Identifier: LaborSanctum
pragma solidity ^0.8.19;

contract WorkerCompensationRouter {
    address public steward;

    struct CompensationSignal {
        string workerNation; // e.g. "South Korea", "Philippines"
        string hostNation; // e.g. "USA", "UK"
        string breachType; // e.g. "Detention", "Deportation", "Wage Theft"
        string compensationType; // e.g. "Financial", "Visa Reform", "Public Apology"
        bool verified;
        uint256 timestamp;
    }

    CompensationSignal[] public signals;

    event CompensationLogged(string workerNation, string hostNation, string breachType, string compensationType, uint256 timestamp);
    event CompensationVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logCompensation(
        string memory workerNation,
        string memory hostNation,
        string memory breachType,
        string memory compensationType
    ) public {
        signals.push(CompensationSignal(workerNation, hostNation, breachType, compensationType, false, block.timestamp));
        emit CompensationLogged(workerNation, hostNation, breachType, compensationType, block.timestamp);
    }

    function verifyCompensation(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit CompensationVerified(index, msg.sender);
    }

    function getCompensation(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        CompensationSignal memory c = signals[index];
        return (c.workerNation, c.hostNation, c.breachType, c.compensationType, c.verified, c.timestamp);
    }

    function totalCompensationSignals() public view returns (uint256) {
        return signals.length;
    }
}
