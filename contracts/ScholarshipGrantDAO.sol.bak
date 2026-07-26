// ScholarshipGrantDAO.sol
pragma solidity ^0.8.0;

contract ScholarshipGrantDAO {
    struct Candidate {
        string name;
        uint256 gpa; // Scaled by 100 (e.g., 1.25 = 125)
        uint256 votes;
        bool awarded;
    }

    mapping(uint256 => Candidate) public candidates;
    uint256 public candidateCount;

    function nominate(string memory _name, uint256 _gpa) public {
        candidateCount++;
        candidates[candidateCount] = Candidate(_name, _gpa, 0, false);
    }

    function voteForScholar(uint256 _id) public {
        candidates[_id].votes++;
        // If consensus reached (e.g., 50 votes), award the scholarship
        if (candidates[_id].votes >= 50) {
            candidates[_id].awarded = true;
        }
    }
}
