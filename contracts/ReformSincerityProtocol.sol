// ReformSincerityProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ReformSincerityProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Reform {
        uint256 id;
        string measure;   // e.g. "Anti-Political Dynasty Bill"
        string sincerity; // e.g. "Verified or Performative"
        uint256 timestamp;
    }

    uint256 public reformCount;
    mapping(uint256 => Reform) public reforms;

    event ReformLogged(uint256 id, string measure, string sincerity);

    function logReform(string memory measure, string memory sincerity) public {
        reformCount++;
        reforms[reformCount] = Reform(reformCount, measure, sincerity, block.timestamp);
        emit ReformLogged(reformCount, measure, sincerity);
    }
}
