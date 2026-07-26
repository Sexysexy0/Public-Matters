pragma solidity ^0.8.0;

contract PerformanceAuditChain {
    event AuditFailure(string game, string issue);

    function runAudit(string memory game, uint256 fps, uint256 crashRate) public {
        if (fps < 30) {
            emit AuditFailure(game, "Low FPS detected");
        }
        if (crashRate > 5) {
            emit AuditFailure(game, "High crash rate detected");
        }
    }
}
