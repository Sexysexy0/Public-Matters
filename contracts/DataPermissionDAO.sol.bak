// DataPermissionDAO.sol
pragma solidity ^0.8.0;

contract DataPermissionDAO {
    struct UsageProposal {
        string appName;
        string dataRequested;
        uint256 approvalVotes;
        bool isCompliant;
    }

    mapping(uint256 => UsageProposal) public proposals;
    uint256 public proposalCount;

    function submitUsagePlan(string memory _app, string memory _data) public {
        proposalCount++;
        proposals[proposalCount] = UsageProposal(_app, _data, 0, false);
    }

    function voteForCompliance(uint256 _id) public {
        proposals[_id].approvalVotes++;
        if (proposals[_id].approvalVotes >= 100) {
            proposals[_id].isCompliant = true;
        }
    }
}
