// AccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract AccountabilityProtocol {
    struct Mechanism {
        uint256 id;
        string system;     // e.g. "Independent Judiciary"
        string safeguard;  // e.g. "Strengthen rule of law and anti-impunity"
        uint256 timestamp;
    }

    uint256 public mechanismCount;
    mapping(uint256 => Mechanism) public mechanisms;

    event MechanismLogged(uint256 id, string system, string safeguard);

    function logMechanism(string memory system, string memory safeguard) public {
        mechanismCount++;
        mechanisms[mechanismCount] = Mechanism(mechanismCount, system, safeguard, block.timestamp);
        emit MechanismLogged(mechanismCount, system, safeguard);
    }
}
