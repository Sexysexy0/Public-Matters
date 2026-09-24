// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract JackSparrowProtocol {
    uint256 private operationalEntropy;
    event ChaosTriggered(address indexed operator, uint256 roll);

    function executeChaosRoll() external returns (uint256 chaosRoll) {
        operationalEntropy++;
        // forge-lint: disable-next-line(weak-prng)
        chaosRoll = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender, operationalEntropy))) % 100;
        emit ChaosTriggered(msg.sender, chaosRoll);
    }
}
