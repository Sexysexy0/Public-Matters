// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacySupportProtocol {
    struct JeepNode {
        bool isRoadworthy;
        bool isModernized;
    }

    // [MIGRATION LOGIC] Preventing a total system crash during modernization
    function authorizeTransit(bool _roadworthy, bool _modernAvailable) public pure returns (string memory) {
        if (!_modernAvailable && _roadworthy) {
            // "If the new system is offline, do not delete the old system."
            return "SIGNAL: AUTHORIZED. Legacy Node activated to fill transit gap.";
        }
        if (_modernAvailable) {
            return "SIGNAL: DEPLOY MODERN. Transitioning to high-efficiency node.";
        }
        return "SIGNAL: CRITICAL FAILURE. No available transport nodes.";
    }
}
