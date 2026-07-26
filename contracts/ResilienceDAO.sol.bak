// ResilienceDAO.sol
pragma solidity ^0.8.0;

contract ResilienceDAO {
    struct Measure {
        uint256 id;
        string domain;   // e.g. "Mobile Security"
        string detail;   // e.g. "Mandatory iOS updates"
        bool active;
    }

    uint256 public measureCount;
    mapping(uint256 => Measure) public measures;

    event MeasureActivated(uint256 id, string domain, string detail);

    function activateMeasure(string memory domain, string memory detail) public {
        measureCount++;
        measures[measureCount] = Measure(measureCount, domain, detail, true);
        emit MeasureActivated(measureCount, domain, detail);
    }
}
