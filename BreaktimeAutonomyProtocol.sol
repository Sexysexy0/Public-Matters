// BreaktimeAutonomyProtocol.sol
pragma solidity ^0.8.0;

contract BreaktimeAutonomyProtocol {
    // Track breaktime allocations per worker
    mapping(address => uint256) public totalBreaktime;
    mapping(address => uint256[]) public breakSegments;

    event BreakScheduled(address indexed worker, uint256 duration);

    // Minimum daily breaktime requirement = 2 hours (120 minutes)
    uint256 public constant MIN_BREAKTIME = 120;

    // Workers decide how to split their breaks (e.g., 30 + 60 + 30)
    function scheduleBreak(address worker, uint256 duration) public {
        totalBreaktime[worker] += duration;
        breakSegments[worker].push(duration);
        emit BreakScheduled(worker, duration);
    }

    // Check if worker met minimum breaktime requirement
    function hasMetBreakRequirement(address worker) public view returns (bool) {
        return totalBreaktime[worker] >= MIN_BREAKTIME;
    }

    // Get all break segments for a worker
    function getBreakSegments(address worker) public view returns (uint256[] memory) {
        return breakSegments[worker];
    }
}
