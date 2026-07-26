// AntiPactSafeguardsDAO.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AntiPactSafeguardsDAO is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Pact {
        uint256 id;
        string seeker;     // e.g. "Occult Practitioner"
        string motive;     // e.g. "Seek fame or wealth"
        string status;     // e.g. "Renounced / Active"
    }

    uint256 public pactCount;
    mapping(uint256 => Pact) public pacts;

    event PactLogged(uint256 id, string seeker, string motive, string status);

    function logPact(string memory seeker, string memory motive, string memory status) public {
        pactCount++;
        pacts[pactCount] = Pact(pactCount, seeker, motive, status);
        emit PactLogged(pactCount, seeker, motive, status);
    }
}
