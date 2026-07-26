// ClimateAdaptationDAO.sol
pragma solidity ^0.8.0;

contract ClimateAdaptationDAO {
    struct Project {
        uint256 id;
        string description;
        uint256 vulnerabilityScore; // 1-100
        uint256 communityVotes;
        bool isApproved;
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectCount;

    function proposeProject(string memory _desc, uint256 _vScore) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, _desc, _vScore, 0, false);
    }

    function vote(uint256 _id) public {
        projects[_id].communityVotes++;
        // Priority logic: Projects with high vulnerability need fewer votes
        if (projects[_id].communityVotes + projects[_id].vulnerabilityScore >= 150) {
            projects[_id].isApproved = true;
        }
    }
}
