// InstitutionalAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract InstitutionalAccountabilityProtocol {
    struct Mechanism {
        uint256 id;
        string body;       // e.g. "Committee on Justice"
        string safeguard;  // e.g. "Checks against misuse of power"
        uint256 timestamp;
    }

    uint256 public mechanismCount;
    mapping(uint256 => Mechanism) public mechanisms;

    event MechanismLogged(uint256 id, string body, string safeguard);

    function logMechanism(string memory body, string memory safeguard) public {
        mechanismCount++;
        mechanisms[mechanismCount] = Mechanism(mechanismCount, body, safeguard, block.timestamp);
        emit MechanismLogged(mechanismCount, body, safeguard);
    }
}
