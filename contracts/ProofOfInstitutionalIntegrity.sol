// ProofOfInstitutionalIntegrity.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProofOfInstitutionalIntegrity is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Transaction { uint256 amount; string purpose; bool verified; }
    Transaction[] public publicLedger;

    function logExpenditure(uint256 _amount, string memory _purpose) public {
        // Administrative Transparency: Every cent must serve the people.
        publicLedger.push(Transaction(_amount, _purpose, true));
    }
}
