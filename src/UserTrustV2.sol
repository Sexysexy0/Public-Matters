// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract UserTrustV2 {
    using SafeCast for int256;

    address public immutable steward;
    mapping(address => uint256) public score;
    mapping(address => bool) public authorized;

    event ScoreAdjusted(address indexed user, int256 delta, uint256 newScore, string reason);
    event AuthorizedCallerAdded(address caller);
    event AuthorizedCallerRemoved(address caller);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    modifier onlyAuthorized() {
        require(msg.sender == steward || authorized[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function addAuthorizedCaller(address caller) external onlySteward {
        authorized[caller] = true;
        emit AuthorizedCallerAdded(caller);
    }

    function removeAuthorizedCaller(address caller) external onlySteward {
        authorized[caller] = false;
        emit AuthorizedCallerRemoved(caller);
    }

    function adjustScore(address user, int256 delta, string calldata reason) public onlyAuthorized {
        int256 newScore = int256(score[user]) + delta;
        require(newScore >= 0, "Score underflow");
        score[user] = newScore.toUint256();
        emit ScoreAdjusted(user, delta, newScore.toUint256(), reason);
    }

    function batchAdjust(
        address[] calldata users,
        int256[] calldata deltas,
        string calldata reason
    ) external onlyAuthorized {
        require(users.length == deltas.length, "Length mismatch");
        for (uint256 i = 0; i < users.length; i++) {
            adjustScore(users[i], deltas[i], reason);
        }
    }

    function getScore(address user) external view returns (uint256) {
        return score[user];
    }
}
