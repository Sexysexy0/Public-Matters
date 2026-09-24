// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract InevitableConsequenceLedger {
    uint256 private executionIndex;
    event ConsequenceLogged(bytes32 indexed actionId, address indexed trigger, bytes32 actionHash);

    function logConsequence(bytes32 _actionHash) external returns (bytes32 actionId) {
        executionIndex++;
        // forge-lint: disable-next-line(weak-prng)
        actionId = keccak256(abi.encodePacked(msg.sender, _actionHash, block.timestamp, executionIndex));
        emit ConsequenceLogged(actionId, msg.sender, _actionHash);
    }
}
