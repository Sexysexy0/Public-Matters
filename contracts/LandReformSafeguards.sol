// LandReformSafeguards.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LandReformSafeguards is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Reform {
        uint256 id;
        string measure;    // e.g. "Equitable Land Distribution"
        string safeguard;  // e.g. "Prevent concentration of resources"
        uint256 timestamp;
    }

    uint256 public reformCount;
    mapping(uint256 => Reform) public reforms;

    event ReformLogged(uint256 id, string measure, string safeguard);

    function logReform(string memory measure, string memory safeguard) public {
        reformCount++;
        reforms[reformCount] = Reform(reformCount, measure, safeguard, block.timestamp);
        emit ReformLogged(reformCount, measure, safeguard);
    }
}
