// JournalismGrantDAO.sol
pragma solidity ^0.8.0;

contract JournalismGrantDAO {
    struct ReportProposal {
        address journalist;
        string topic;
        uint256 budgetRequest;
        uint256 communityVotes;
        bool funded;
    }

    mapping(uint256 => ReportProposal) public proposals;
    uint256 public proposalCount;

    function proposeStory(string memory _topic, uint256 _budget) public {
        proposalCount++;
        proposals[proposalCount] = ReportProposal(msg.sender, _topic, _budget, 0, false);
    }

    function voteForStory(uint256 _id) public {
        proposals[_id].communityVotes++;
        // Threshold check to release grant
        if (proposals[_id].communityVotes > 100) {
            proposals[_id].funded = true;
        }
    }
}
