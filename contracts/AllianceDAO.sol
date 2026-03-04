// AllianceDAO.sol
pragma solidity ^0.8.0;

contract AllianceDAO {
    struct Pact {
        uint256 id;
        string partner;   // e.g. "Regional Bloc"
        string detail;    // e.g. "Defense cooperation"
        bool active;
    }

    uint256 public pactCount;
    mapping(uint256 => Pact) public pacts;

    event PactFormed(uint256 id, string partner, string detail);
    event PactActivated(uint256 id, string partner);

    function formPact(string memory partner, string memory detail) public {
        pactCount++;
        pacts[pactCount] = Pact(pactCount, partner, detail, false);
        emit PactFormed(pactCount, partner, detail);
    }

    function activatePact(uint256 id) public {
        pacts[id].active = true;
        emit PactActivated(id, pacts[id].partner);
    }
}
