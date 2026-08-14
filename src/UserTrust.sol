// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract UserTrust {
    using SafeCast for int256;

    address public immutable steward;
    mapping(address => uint256) public score;

    event ScoreAdjusted(address indexed user, int256 delta, uint256 newScore, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function adjustScore(address user, int256 delta, string calldata reason) public onlySteward {
        int256 newScore = int256(score[user]) + delta;
        require(newScore >= 0, "Score underflow");
        score[user] = newScore.toUint256();
        emit ScoreAdjusted(user, delta, newScore.toUint256(), reason);
    }

    function batchAdjust(address[] calldata users, int256[] calldata deltas, string calldata reason)
        external
        onlySteward
    {
        require(users.length == deltas.length, "Length mismatch");
        for (uint256 i = 0; i < users.length; i++) {
            adjustScore(users[i], deltas[i], reason);
        }
    }

    function getScore(address user) external view returns (uint256) {
        return score[user];
    }
}
