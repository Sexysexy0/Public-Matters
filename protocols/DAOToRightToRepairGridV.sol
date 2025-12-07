// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * DAOToRightToRepairGridV — Batch 1321.9.261
 * Focus: communal resistance grid against corporate greed
 */
contract DAOToRightToRepairGridV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Proposal {
        string id;
        string title;
        string description;
        bool executed;
        uint256 timestamp;
    }

    mapping(bytes32 => Proposal) public proposals;

    event ProposalCreated(bytes32 indexed key, string id, string title);
    event ProposalExecuted(bytes32 indexed key, string id);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory id) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(id));
    }

    function createProposal(
        string calldata id,
        string calldata title,
        string calldata description
    ) external onlySteward {
        bytes32 k = keyFor(id);
        proposals[k] = Proposal(id, title, description, false, block.timestamp);
        emit ProposalCreated(k, id, title);
    }

    function executeProposal(string calldata id) external onlySteward {
        bytes32 k = keyFor(id);
        Proposal storage p = proposals[k];
        require(!p.executed, "already executed");
        p.executed = true;
        emit ProposalExecuted(k, id);
    }
}
