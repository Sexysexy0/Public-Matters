// SPDX-License-Identifier: InnovationSanctum
pragma solidity ^0.8.19;

contract InnovationReserveScanner {
    address public steward;

    struct InnovationSignal {
        string nationTag; // e.g. "USA", "China", "EU"
        string techDomain; // e.g. "AI", "Quantum", "Biotech", "Semiconductors"
        string supremacySignal; // e.g. "Dominant", "Lagging", "Disputed"
        bool verified;
        uint256 timestamp;
    }

    InnovationSignal[] public signals;

    event InnovationLogged(string nationTag, string techDomain, string supremacySignal, uint256 timestamp);
    event InnovationVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logInnovation(
        string memory nationTag,
        string memory techDomain,
        string memory supremacySignal
    ) public {
        signals.push(InnovationSignal(nationTag, techDomain, supremacySignal, false, block.timestamp));
        emit InnovationLogged(nationTag, techDomain, supremacySignal, block.timestamp);
    }

    function verifyInnovation(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit InnovationVerified(index, msg.sender);
    }

    function getInnovation(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        InnovationSignal memory i = signals[index];
        return (i.nationTag, i.techDomain, i.supremacySignal, i.verified, i.timestamp);
    }

    function totalInnovationSignals() public view returns (uint256) {
        return signals.length;
    }
}
