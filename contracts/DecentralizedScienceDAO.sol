// DecentralizedScienceDAO.sol
pragma solidity ^0.8.0;

contract DecentralizedScienceDAO {
    struct ResearchProject {
        string title;
        uint256 fundingPool;
        uint256 peerReviewScore;
        bool resultIsPublic;
    }

    mapping(uint256 => ResearchProject) public projects;
    uint256 public projectCount;

    function fundResearch(string memory _title) public payable {
        projectCount++;
        projects[projectCount] = ResearchProject(_title, msg.value, 0, false);
    }

    function submitPeerReview(uint256 _id, uint256 _score) public {
        // Only verified scientists in the DAO can score
        projects[_id].peerReviewScore += _score;
        if (projects[_id].peerReviewScore > 500) {
            projects[_id].resultIsPublic = true;
        }
    }
}
