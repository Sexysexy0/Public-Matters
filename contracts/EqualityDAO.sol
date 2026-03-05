// EqualityDAO.sol
pragma solidity ^0.8.0;

contract EqualityDAO {
    struct Policy {
        uint256 id;
        string sector;   // e.g. "Workplace"
        string detail;   // e.g. "Equal pay initiative"
        bool enacted;
    }

    uint256 public policyCount;
    mapping(uint256 => Policy) public policies;

    event PolicyEnacted(uint256 id, string sector, string detail);

    function enactPolicy(string memory sector, string memory detail) public {
        policyCount++;
        policies[policyCount] = Policy(policyCount, sector, detail, true);
        emit PolicyEnacted(policyCount, sector, detail);
    }
}
