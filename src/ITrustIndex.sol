// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrustIndex {
    function reportTrustAction(uint256 weight) external;
    function reportTrustSetback(uint256 weight) external;
    function getTrustIndex() external view returns (uint256);
}
