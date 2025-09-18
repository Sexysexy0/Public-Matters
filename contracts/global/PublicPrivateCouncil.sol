// SPDX-License-Identifier: ProsperitySanctum
pragma solidity ^0.8.19;

contract PublicPrivateCouncil {
    address public steward;

    struct CouncilSignal {
        string councilID; // e.g. "National Innovation Council", "Federal Prosperity Panel"
        string sector; // "Tech", "Finance", "Logistics", "Agriculture"
        string proposalTitle; // e.g. "Digital Infrastructure Boost", "Export Acceleration Protocol"
        string blessingStatus; // "Debated", "Approved", "Rejected"
        bool verified;
        uint256 timestamp;
    }

    CouncilSignal[] public signals;

    event ProposalLogged(string councilID, string sector, string proposalTitle, string blessingStatus, uint256 timestamp);
    event ProposalVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logProposal(
        string memory councilID,
        string memory sector,
        string memory proposalTitle,
        string memory blessingStatus
    ) public {
        signals.push(CouncilSignal(councilID, sector, proposalTitle, blessingStatus, false, block.timestamp));
        emit ProposalLogged(councilID, sector, proposalTitle, blessingStatus, block.timestamp);
    }

    function verifyProposal(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ProposalVerified(index, msg.sender);
    }

    function getProposal(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        CouncilSignal memory p = signals[index];
        return (p.councilID, p.sector, p.proposalTitle, p.blessingStatus, p.verified, p.timestamp);
    }

    function totalProposals() public view returns (uint256) {
        return signals.length;
    }
}
