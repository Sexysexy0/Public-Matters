pragma solidity ^0.8.0;

contract ContractIntegrityLedger {
    event IntegrityViolation(string contractId, string issue);

    function logContract(string memory contractId, bool tampered) public {
        if (tampered) {
            emit IntegrityViolation(contractId, "Contract tampering or leak detected");
        }
    }
}
