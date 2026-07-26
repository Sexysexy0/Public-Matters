// TransportSubsidyDAO.sol
pragma solidity ^0.8.0;

contract TransportSubsidyDAO {
    struct Allocation {
        uint256 id;
        string transportSector; // e.g. "Jeepney Operators"
        uint256 amountRequested;
        uint256 approvalVotes;
        bool disbursed;
    }

    mapping(uint256 => Allocation) public allocations;
    uint256 public totalRequests;

    function proposeSubsidy(string memory _sector, uint256 _amount) public {
        totalRequests++;
        allocations[totalRequests] = Allocation(totalRequests, _sector, _amount, 0, false);
    }

    function voteForSubsidy(uint256 _id) public {
        require(!allocations[_id].disbursed, "Already disbursed");
        allocations[_id].approvalVotes += 1;
        
        // Logic: Auto-disburse if consensus is met (simplified)
        if (allocations[_id].approvalVotes >= 10) { 
            allocations[_id].disbursed = true;
        }
    }
}
