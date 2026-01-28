pragma solidity ^0.8.20;

contract BubbleRiskProtocol {
    address public admin;

    struct Bubble {
        string driver;       // e.g. hype, investor rush
        string signal;       // e.g. no profits, inflated valuations
        string consequence;  // e.g. collapse, consolidation
        uint256 timestamp;
    }

    Bubble[] public bubbles;

    event BubbleLogged(string driver, string signal, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBubble(string calldata driver, string calldata signal, string calldata consequence) external onlyAdmin {
        bubbles.push(Bubble(driver, signal, consequence, block.timestamp));
        emit BubbleLogged(driver, signal, consequence, block.timestamp);
    }

    function totalBubbles() external view returns (uint256) {
        return bubbles.length;
    }
}
