// PeaceResonanceProtocol.sol
pragma solidity ^0.8.0;

contract PeaceResonanceProtocol {
    struct Accord {
        uint256 id;
        string region;    // e.g. "Border Zone"
        string measure;   // e.g. "Ceasefire agreement"
        string outcome;   // e.g. "Stable"
        uint256 timestamp;
    }

    uint256 public accordCount;
    mapping(uint256 => Accord) public accords;

    event AccordLogged(uint256 id, string region, string measure, string outcome);

    function logAccord(string memory region, string memory measure, string memory outcome) public {
        accordCount++;
        accords[accordCount] = Accord(accordCount, region, measure, outcome, block.timestamp);
        emit AccordLogged(accordCount, region, measure, outcome);
    }
}
