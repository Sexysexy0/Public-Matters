// CivicDAO.sol
pragma solidity ^0.8.0;

contract CivicDAO {
    struct Policy {
        uint256 id;
        string domain;   // e.g. "Community Rights"
        string detail;   // e.g. "Open internet access"
        bool enacted;
    }

    uint256 public policyCount;
    mapping(uint256 => Policy) public policies;

    event PolicyEnacted(uint256 id, string domain, string detail);

    function enactPolicy(string memory domain, string memory detail) public {
        policyCount++;
        policies[policyCount] = Policy(policyCount, domain, detail, true);
        emit PolicyEnacted(policyCount, domain, detail);
    }
}
