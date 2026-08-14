// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITransparencyLedger {
    function logTransaction(
        address user,
        uint256 amount,
        string memory category,
        uint256 timestamp
    ) external;
}
