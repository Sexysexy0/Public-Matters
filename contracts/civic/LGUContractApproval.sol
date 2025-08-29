// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract LGUContractApproval {
    address public steward;
    mapping(address => bool) public approvedLGUs;

    struct ContractProposal {
        string projectName;
        string contractor;
        uint256 budget;
        string location;
        bool approved;
        bool rejected;
        bool emotionallyTagged;
        address lgu;
    }

    ContractProposal[] public proposals;

    event ProposalSubmitted(uint256 indexed id, string projectName, address lgu);
    event ProposalApproved(uint256 indexed id, string projectName, address lgu);
    event ProposalRejected(uint256 indexed id, string projectName, address lgu);
    event EmotionalTagApplied(uint256 indexed id, string projectName, string tag);

    modifier onlyLGU() {
        require(approvedLGUs[msg.sender], "Not an approved LGU");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerLGU(address lgu) public {
        require(msg.sender == steward, "Only steward may register LGUs");
        approvedLGUs[lgu] = true;
    }

    function submitProposal(
        string memory projectName,
        string memory contractor,
        uint256 budget,
        string memory location
    ) public onlyLGU {
        proposals.push(ContractProposal(projectName, contractor, budget, location, false, false, false, msg.sender));
        emit ProposalSubmitted(proposals.length - 1, projectName, msg.sender);
    }

    function approveProposal(uint256 id) public onlyLGU {
        require(!proposals[id].approved && !proposals[id].rejected, "Already resolved");
        proposals[id].approved = true;
        emit ProposalApproved(id, proposals[id].projectName, msg.sender);
    }

    function rejectProposal(uint256 id) public onlyLGU {
        require(!proposals[id].approved && !proposals[id].rejected, "Already resolved");
        proposals[id].rejected = true;
        emit ProposalRejected(id, proposals[id].projectName, msg.sender);
    }

    function applyEmotionalTag(uint256 id, string memory tag) public onlyLGU {
        proposals[id].emotionallyTagged = true;
        emit EmotionalTagApplied(id, proposals[id].projectName, tag);
    }

    function getProposal(uint256 id) public view returns (ContractProposal memory) {
        return proposals[id];
    }

    function totalProposals() public view returns (uint256) {
        return proposals.length;
    }
}
