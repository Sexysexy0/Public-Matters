// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract TrustIndex {
    OperatorPrivileges public privileges;
    mapping(address => int256) public trustScores;

    event TrustUpdated(address indexed user, int256 newScore);

    constructor(address _privileges) {
        privileges = OperatorPrivileges(_privileges);
    }

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    function updateTrust(address user, int256 delta) external onlyOperator {
        int256 newScore = trustScores[user] + delta;
        if (newScore < 0) newScore = 0;
        trustScores[user] = newScore;
        emit TrustUpdated(user, newScore);
    }

    function getTrust(address user) external view returns (int256) {
        return trustScores[user];
    }
}
