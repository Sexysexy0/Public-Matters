// ClimateSafeguards.sol
pragma solidity ^0.8.0;

contract ClimateSafeguards {
    struct Measure {
        uint256 id;
        string action;     // e.g. "Reduce carbon emissions"
        string safeguard;  // e.g. "Protect ecosystems from degradation"
        uint256 timestamp;
    }

    uint256 public measureCount;
    mapping(uint256 => Measure) public measures;

    event MeasureLogged(uint256 id, string action, string safeguard);

    function logMeasure(string memory action, string memory safeguard) public {
        measureCount++;
        measures[measureCount] = Measure(measureCount, action, safeguard, block.timestamp);
        emit MeasureLogged(measureCount, action, safeguard);
    }
}
