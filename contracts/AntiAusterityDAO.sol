// AntiAusterityDAO.sol
pragma solidity ^0.8.0;

contract AntiAusterityDAO {
    struct Measure {
        uint256 id;
        string policy;   // e.g. "Subsidize renewable energy"
        string impact;   // e.g. "Lower household costs"
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
