// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuditHistory {
    function logHistoricalAction(
        address _institution,
        uint256 _freezeCount,
        uint256 _grantCount,
        uint256 _warningCount,
        bytes32 _actionLog
    ) external;
}
