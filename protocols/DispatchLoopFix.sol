// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DispatchLoopFix {
    // [Goal: Ensure exploration missions loop correctly upon completion]
    function resetMissionStatus(bool _isCompleted) external pure returns (string memory) {
        if (_isCompleted) {
            return "RESET: Dispatch mission status refreshed. Ready for next loop.";
        }
        return "ACTIVE: Mission still in progress.";
    }
}
