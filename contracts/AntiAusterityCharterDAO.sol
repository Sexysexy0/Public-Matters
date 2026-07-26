// AntiAusterityCharterDAO.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AntiAusterityCharterDAO is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Measure {
        uint256 id;
        string policy;   // e.g. "Affordable Energy Transition"
        string impact;   // e.g. "Lower household burden"
        bool active;
    }

    uint256 public measureCount;
    mapping(uint256 => Measure) public measures;

    event MeasureActivated(uint256 id, string policy, string impact);

    function activateMeasure(string memory policy, string memory impact) public {
        measureCount++;
        measures[measureCount] = Measure(measureCount, policy, impact, true);
        emit MeasureActivated(measureCount, policy, impact);
    }
}
