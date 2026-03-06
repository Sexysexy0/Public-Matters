// InnovationAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract InnovationAccountabilityProtocol {
    struct Check {
        uint256 id;
        string technology; // e.g. "Blockchain"
        string safeguard;  // e.g. "Ensure tech serves human dignity"
        uint256 timestamp;
    }

    uint256 public checkCount;
    mapping(uint256 => Check) public checks;

    event CheckLogged(uint256 id, string technology, string safeguard);

    function logCheck(string memory technology, string memory safeguard) public {
        checkCount++;
        checks[checkCount] = Check(checkCount, technology, safeguard, block.timestamp);
        emit CheckLogged(checkCount, technology, safeguard);
    }
}
