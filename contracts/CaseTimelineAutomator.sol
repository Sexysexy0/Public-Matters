// CaseTimelineAutomator.sol
pragma solidity ^0.8.0;

contract CaseTimelineAutomator {
    struct LegalCase {
        uint256 caseId;
        uint256 dateFiled;
        uint256 deadline;
        bool isResolved;
        string status;
    }

    mapping(uint256 => LegalCase) public courtCalendar;

    function logCase(uint256 _id, uint256 _durationDays) public {
        uint256 limit = block.timestamp + (_durationDays * 1 days);
        courtCalendar[_id] = LegalCase(_id, block.timestamp, limit, false, "Ongoing");
    }

    function checkDelay(uint256 _id) public view returns (string memory) {
        if (!courtCalendar[_id].isResolved && block.timestamp > courtCalendar[_id].deadline) {
            return "ALARM: Mandatory Review Required. Case is overdue.";
        }
        return "Within legal timeframe.";
    }
}
