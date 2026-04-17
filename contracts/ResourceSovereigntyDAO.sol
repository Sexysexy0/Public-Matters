// ResourceSovereigntyDAO.sol
pragma solidity ^0.8.0;

contract ResourceSovereigntyDAO {
    struct Project {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool isApproved;
    }

    Project[] public projects;

    function proposeProject(string memory _desc) public {
        projects.push(Project(_desc, 0, 0, false));
    }

    function vote(uint256 _id, bool _support) public {
        if (_support) projects[_id].votesFor++;
        else projects[_id].votesAgainst++;
        
        if (projects[_id].votesFor > projects[_id].votesAgainst + 100) { // Simple consensus
            projects[_id].isApproved = true;
        }
    }
}
