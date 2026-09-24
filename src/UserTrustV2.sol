// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract UserTrustV2 {
    address public poolAdmin;
    constructor() {
        poolAdmin = msg.sender;
    }

    function batchValidateScores(int256[] calldata scores) external view {
        require(msg.sender == poolAdmin, "Not pool admin");
        for (uint256 i = 0; i < scores.length; i++) {
            int256 newScore = scores[i];
            // forge-lint: disable-next-line(require-revert-in-loop)
            require(newScore >= 0, "Score underflow");
        }
    }
}
