pragma solidity ^0.8.0;

contract SchoolSafetyProtocol {
    event SafetyAlert(string school, string issue);

    function detectThreat(string memory school, bool attacked) public {
        if (attacked) {
            emit SafetyAlert(school, "School attacked – civilian protection safeguard activated");
        }
    }
}
