// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title JackSparrowProtocol (Bonus Arc)
 * @dev Randomizes outcomes, rewarding cunning improvisation and chaos.
 */
contract JackSparrowProtocol {
    address public masterPirate;
    mapping(address => uint256) public infamyScore;

    event ChaosUnleashed(address indexed player, uint256 roll, string result);

    constructor() {
        masterPirate = msg.sender;
    }

    function chaosPlay() external returns (uint256) {
        // Pseudo-random roll between 0 and 99
        uint256 chaosRoll = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 100;
        
        string memory resultMsg;
        if (chaosRoll > 50) {
            infamyScore[msg.sender] += 10;
            resultMsg = "Fortune favors the bold! Infamy increased.";
        } else {
            if (infamyScore[msg.sender] >= 5) {
                infamyScore[msg.sender] -= 5;
            }
            resultMsg = "A bit of bad luck, mate. Try again.";
        }

        emit ChaosUnleashed(msg.sender, chaosRoll, resultMsg);
        return chaosRoll;
    }
}
