pragma solidity ^0.8.20;

contract CyclePositioningProtocol {
    address public admin;

    struct Positioning {
        string cycle;        // e.g. 4-year halving cycle
        string phase;        // e.g. consolidation, breakout, surge
        string strategy;     // e.g. accumulate, rotate, trim
        uint256 timestamp;
    }

    Positioning[] public positionings;

    event PositioningLogged(string cycle, string phase, string strategy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPositioning(string calldata cycle, string calldata phase, string calldata strategy) external onlyAdmin {
        positionings.push(Positioning(cycle, phase, strategy, block.timestamp));
        emit PositioningLogged(cycle, phase, strategy, block.timestamp);
    }

    function totalPositionings() external view returns (uint256) {
        return positionings.length;
    }
}
