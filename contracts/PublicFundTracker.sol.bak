// PublicFundTracker.sol
pragma solidity ^0.8.0;

contract PublicFundTracker {
    struct ProjectFund {
        string projectName;
        uint256 totalBudget;
        uint256 releasedAmount;
        bool isCompleted;
    }

    mapping(uint256 => ProjectFund) public projects;

    function releaseMilestone(uint256 _projectId, uint256 _amount, string memory _proofHash) public {
        // Ang _proofHash ay link sa digital evidence ng progress
        require(!projects[_projectId].isCompleted, "Project already closed");
        projects[_projectId].releasedAmount += _amount;
        
        // Logic: Hindi pwede lumampas sa budget
        require(projects[_projectId].releasedAmount <= projects[_projectId].totalBudget, "Overbudget!");
    }
}
