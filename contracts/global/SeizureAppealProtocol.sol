// SPDX-License-Identifier: RecoverySanctum
pragma solidity ^0.8.19;

contract SeizureAppealProtocol {
    struct AppealCase {
        address claimant;
        uint256 amountSeized;
        string seizureLocation;
        string authorityInvolved;
        string justificationClaimed;
        bool verifiedInnocent;
        string recoveryStatus;
        string stewardNote;
    }

    mapping(address => AppealCase) public appeals;

    event AppealFiled(address claimant, uint256 amountSeized);
    event InnocenceVerified(address claimant);
    event RecoveryLogged(address claimant, string recoveryStatus);

    function fileAppeal(address claimant, uint256 amountSeized, string memory seizureLocation, string memory authorityInvolved, string memory justificationClaimed, string memory stewardNote) public {
        appeals[claimant] = AppealCase(claimant, amountSeized, seizureLocation, authorityInvolved, justificationClaimed, false, "Pending", stewardNote);
        emit AppealFiled(claimant, amountSeized);
    }

    function verifyInnocence(address claimant) public {
        appeals[claimant].verifiedInnocent = true;
        emit InnocenceVerified(claimant);
    }

    function logRecovery(address claimant, string memory recoveryStatus) public {
        appeals[claimant].recoveryStatus = recoveryStatus;
        emit RecoveryLogged(claimant, recoveryStatus);
    }

    function getAppealStatus(address claimant) public view returns (AppealCase memory) {
        return appeals[claimant];
    }
}
