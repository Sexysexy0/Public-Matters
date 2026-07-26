// CommunityDisputeDAO.sol
pragma solidity ^0.8.0;

contract CommunityDisputeDAO {
    struct Case {
        uint256 id;
        address partyA;
        address partyB;
        string issue;
        uint256 arbitratorVotes;
        bool settled;
    }

    mapping(uint256 => Case) public court;
    uint256 public caseCount;

    function fileDispute(address _otherParty, string memory _issue) public {
        caseCount++;
        court[caseCount] = Case(caseCount, msg.sender, _otherParty, _issue, 0, false);
    }

    function resolveCase(uint256 _id) public {
        // Arbitrators vote to confirm settlement terms
        court[_id].arbitratorVotes++;
        if (court[_id].arbitratorVotes >= 5) {
            court[_id].settled = true;
        }
    }
}
