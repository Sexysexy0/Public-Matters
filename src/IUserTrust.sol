// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUserTrust {
    function adjustScore(address user, int256 delta, string calldata reason) external;
    function getScore(address user) external view returns (uint256);
}
