// CollectiveWealthDAOfund.sol
pragma solidity ^0.8.0;

contract CollectiveWealthDAOfund {
    uint256 public collectiveBalance;

    struct ExpenseProposal {
        string purpose; // e.g. "Community Clinic"
        uint256 amount;
        uint256 votes;
        bool executed;
    }

    ExpenseProposal[] public proposals;

    function voteForProposal(uint256 _id) public {
        proposals[_id].votes++;
        if (proposals[_id].votes > 50) { // Majority rule
            executeExpense(_id);
        }
    }

    function executeExpense(uint256 _id) internal {
        require(!proposals[_id].executed);
        payable(msg.sender).transfer(proposals[_id].amount);
        proposals[_id].executed = true;
    }
}
