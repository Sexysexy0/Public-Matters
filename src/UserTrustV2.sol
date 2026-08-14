// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserTrustV2 {
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
        // forge-lint: disable-next-line unsafe-typecast
        score[user] = uint256(newScore);
        // forge-lint: disable-next-line unsafe-typecast
        emit ScoreAdjusted(user, delta, uint256(newScore), reason);
    }

    function batchAdjust(address[] calldata users, int256[] calldata deltas, string calldata reason)
        external
        onlyAuthorized
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
