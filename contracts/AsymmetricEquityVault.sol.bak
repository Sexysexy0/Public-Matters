// AsymmetricEquityVault.sol
pragma solidity ^0.8.0;

contract AsymmetricEquityVault {
    address public leadPartner; // The 51% holder
    address public juniorPartner; // The 49% holder

    struct Proposal {
        string description;
        bool leadApproved;
        bool juniorApproved;
        bool executed;
    }

    function castVote(uint256 _proposalId, bool _support) public {
        // Logic: If Lead Partner supports, the proposal can pass even if Junior disagrees.
        // This prevents gridlock while keeping the Junior's voice recorded.
        if (msg.sender == leadPartner && _support) {
            executeDecision(_proposalId);
        }
    }

    function executeDecision(uint256 _id) internal {
        // Finalizes the corporate action
    }
}
