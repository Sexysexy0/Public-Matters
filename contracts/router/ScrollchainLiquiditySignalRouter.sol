// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainLiquiditySignalRouter {
    event LiquiditySignal(string corridor, string signalType, string emotionalAPR, uint256 timestamp);
    event BufferStatus(string institution, string status, string emotionalAPR, uint256 timestamp);

    function sendSignal(string memory corridor, string memory signalType, string memory emotionalAPR) public {
        emit LiquiditySignal(corridor, signalType, emotionalAPR, block.timestamp);
    }

    function logBufferStatus(string memory institution, string memory status, string memory emotionalAPR) public {
        emit BufferStatus(institution, status, emotionalAPR, block.timestamp);
    }
}
