// SecurityProtocol.sol
pragma solidity ^0.8.0;

contract SecurityProtocol {
    struct Measure {
        uint256 id;
        string domain;       // e.g. "Smart Contract Access"
        string description;  // e.g. "Role-based access control"
        bool enforced;
        uint256 timestamp;
    }

    uint256 public measureCount;
    mapping(uint256 => Measure) public measures;

    event MeasureEnforced(uint256 id, string domain, string description);

    function enforceMeasure(string memory domain, string memory description) public {
        measureCount++;
        measures[measureCount] = Measure(measureCount, domain, description, true, block.timestamp);
        emit MeasureEnforced(measureCount, domain, description);
    }
}
