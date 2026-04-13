// LaborCollectiveDAO.sol
pragma solidity ^0.8.0;

contract LaborCollectiveDAO {
    struct LaborProposal {
        string description; // e.g. "Hazard pay for transport workers"
        uint256 voteCount;
        bool approved;
        mapping(address => bool) hasVoted;
    }

    uint256 public proposalCount;
    mapping(uint256 => LaborProposal) public proposals;

    function createProposal(string memory _desc) public {
        proposalCount++;
        proposals[proposalCount].description = _desc;
    }

    function castVote(uint256 _id) public {
        require(!proposals[_id].hasVoted[msg.sender], "Already voted");
        proposals[_id].voteCount++;
        proposals[_id].hasVoted[msg.sender] = true;
        
        if (proposals[_id].voteCount > 50) { // Majority rule
            proposals[_id].approved = true;
        }
    }
}
