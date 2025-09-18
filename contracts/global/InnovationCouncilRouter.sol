// SPDX-License-Identifier: InnovationSanctum
pragma solidity ^0.8.19;

contract InnovationCouncilRouter {
    address public steward;

    struct InnovationSignal {
        string councilID; // e.g. "National Innovation Council", "Prosperity Acceleration Panel"
        string proposalTitle; // e.g. "AI Infrastructure Boost", "Green Logistics Protocol"
        string blessingStatus; // "Debated", "Approved", "Rejected"
        string stewardTag; // e.g. "Tech Founder #12", "Logistics Steward #7"
        bool verified;
        uint256 timestamp;
    }

    InnovationSignal[] public signals;

    event InnovationLogged(string councilID, string proposalTitle, string blessingStatus, string stewardTag, uint256 timestamp);
    event InnovationVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logInnovation(
        string memory councilID,
        string memory proposalTitle,
        string memory blessingStatus,
        string memory stewardTag
    ) public {
        signals.push(InnovationSignal(councilID, proposalTitle, blessingStatus, stewardTag, false, block.timestamp));
        emit InnovationLogged(councilID, proposalTitle, blessingStatus, stewardTag, block.timestamp);
    }

    function verifyInnovation(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit InnovationVerified(index, msg.sender);
    }

    function getInnovation(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        InnovationSignal memory i = signals[index];
        return (i.councilID, i.proposalTitle, i.blessingStatus, i.stewardTag, i.verified, i.timestamp);
    }

    function totalInnovationSignals() public view returns (uint256) {
        return signals.length;
    }
}
