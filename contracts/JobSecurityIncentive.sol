// JobSecurityIncentive.sol
// Logic: Linking Hiring Status to Loan Priority
pragma solidity ^0.8.0;

contract JobSecurityIncentive {
    function verifyHiringStatus(bool _isHiringFreezeActive) public pure returns (string memory) {
        if (!_isHiringFreezeActive) {
            return "PRIORITY_GRANTED: ACCESS TO DOLE STANDBY FUNDS & SOFT LOANS";
        }
        return "WARNING: RESTRICTED ACCESS | PLEASE REVOKE HIRING FREEZE TO QUALIFY";
    }
}
