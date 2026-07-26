pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ContractIntegrityLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event IntegrityViolation(string contractId, string issue);

    function logContract(string memory contractId, bool tampered) public {
        if (tampered) {
            emit IntegrityViolation(contractId, "Contract tampering or leak detected");
        }
    }
}
