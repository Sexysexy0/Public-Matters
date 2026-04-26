// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CoOpBridge {
    event CoOpRecord(string player, string style);

    function logCoOp(string memory player, string memory style) external {
        emit CoOpRecord(player, style);
        // BRIDGE: Co-op combat styles logged for governance.
    }
}
