// ValidationResonanceProtocol.sol
pragma solidity ^0.8.0;

contract ValidationResonanceProtocol {
    struct Check {
        uint256 id;
        string domain;    // e.g. "API Calls"
        string criteria;  // e.g. "Response time < 200ms"
        string outcome;   // e.g. "Valid", "Invalid"
        uint256 timestamp;
    }

    uint256 public checkCount;
    mapping(uint256 => Check) public checks;

    event CheckLogged(uint256 id, string domain, string criteria, string outcome);

    function logCheck(string memory domain, string memory criteria, string memory outcome) public {
        checkCount++;
        checks[checkCount] = Check(checkCount, domain, criteria, outcome, block.timestamp);
        emit CheckLogged(checkCount, domain, criteria, outcome);
    }
}
