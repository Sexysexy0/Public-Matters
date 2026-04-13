// UptimeAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract UptimeAccountabilityProtocol {
    struct CriticalTask {
        uint256 taskId;
        uint256 deadline;
        bool isCompleted;
        address responsibleOfficial;
    }

    mapping(uint256 => CriticalTask) public taskBoard;

    function assignTask(uint256 _id, address _official, uint256 _timeLimit) public {
        taskBoard[_id] = CriticalTask(_id, block.timestamp + _timeLimit, false, _official);
    }

    function checkNeglect(uint256 _id) public view returns (string memory) {
        if (block.timestamp > taskBoard[_id].deadline && !taskBoard[_id].isCompleted) {
            return "ALERT: Response Deadline Exceeded. Official Accountability Triggered.";
        }
        return "STATUS: Within Operational Timeline.";
    }
}
