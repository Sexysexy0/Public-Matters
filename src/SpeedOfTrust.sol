// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SpeedOfTrust {
    mapping(address => uint256) public trustIndex;

    event TrustUpdated(address agent, uint256 newIndex);

    function updateTrust(address agent, uint256 value) external {
        trustIndex[agent] = value;
        emit TrustUpdated(agent, value);
    }

    function canExecute(address agent) external view returns (bool) {
        return trustIndex[agent] > 50; // threshold trust score
    }
}
