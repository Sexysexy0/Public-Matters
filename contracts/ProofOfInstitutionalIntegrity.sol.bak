// ProofOfInstitutionalIntegrity.sol
pragma solidity ^0.8.0;

contract ProofOfInstitutionalIntegrity {
    struct Transaction { uint256 amount; string purpose; bool verified; }
    Transaction[] public publicLedger;

    function logExpenditure(uint256 _amount, string memory _purpose) public {
        // Administrative Transparency: Every cent must serve the people.
        publicLedger.push(Transaction(_amount, _purpose, true));
    }
}
