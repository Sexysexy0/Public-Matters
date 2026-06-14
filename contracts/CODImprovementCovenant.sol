// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CODImprovementCovenant
/// @notice Covenant contract encoding player-requested improvements and accountability
contract CODImprovementCovenant {
    address public overseer;
    uint256 public proposalCount;

    struct ImprovementProposal {
        uint256 id;
        string category;    // cosmetics, UI, marketing, innovation
        string promise;     // what developers pledged
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ImprovementProposal) public proposals;

    event ProposalLogged(uint256 indexed id, string category, string promise, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs improvement proposal
    function logProposal(string calldata category, string calldata promise, string calldata safeguard, string calldata notes) external onlyOverseer {
        proposalCount++;
        proposals[proposalCount] = ImprovementProposal({
            id: proposalCount,
            category: category,
            promise: promise,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ProposalLogged(proposalCount, category, promise, safeguard);
    }

    /// @notice Citizens can view improvement proposals
    function viewProposal(uint256 id) external view returns (ImprovementProposal memory) {
        return proposals[id];
    }
}
