pragma solidity ^0.8.0;

contract HumaneReliefShield {
    event ReliefAlert(string caseDetail, string issue);

    function detectIssue(string memory caseDetail, bool issueDetected) public {
        if (issueDetected) {
            emit ReliefAlert(caseDetail, "Humane safeguard required – dignity and relief activated");
        }
    }
}
