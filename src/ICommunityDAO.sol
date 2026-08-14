// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICommunityDAO {
    function propose(address target, bytes calldata data, string calldata description) external returns (uint256);
    function vote(uint256 proposalId, bool support) external;
    function execute(uint256 proposalId) external;
}
