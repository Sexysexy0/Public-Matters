// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract APROracle {
    address public steward;

    mapping(address => uint8) public aprScores;

    event APRUpdated(address indexed vendor, uint8 newScore);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function updateAPR(address vendor, uint8 score) external onlySteward {
        require(score <= 100, "Invalid APR score");
        aprScores[vendor] = score;
        emit APRUpdated(vendor, score);
    }

    function getAPR(address vendor) external view returns (uint8) {
        return aprScores[vendor];
    }
}
