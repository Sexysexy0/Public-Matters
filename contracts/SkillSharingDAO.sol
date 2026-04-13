// SkillSharingDAO.sol
pragma solidity ^0.8.0;

contract SkillSharingDAO {
    struct Session {
        address mentor;
        address student;
        string skill; // e.g., "Prompt Engineering"
        bool completed;
        uint256 rewardAmount;
    }

    mapping(uint256 => Session) public sessions;
    uint256 public sessionCount;

    function logSession(address _student, string memory _skill, uint256 _reward) public {
        sessionCount++;
        sessions[sessionCount] = Session(msg.sender, _student, _skill, false, _reward);
    }

    function confirmCompletion(uint256 _id) public {
        // Student confirms the session was helpful
        require(msg.sender == sessions[_id].student, "Only student can confirm");
        sessions[_id].completed = true;
        // Logic to trigger reward release
    }
}
