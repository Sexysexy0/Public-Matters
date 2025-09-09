// SPDX-License-Identifier: SanctumRecoveryContinuity-License
pragma solidity ^0.8.0;

contract SanctumRecoveryContinuityOracle {
    address public steward;

    struct RecoverySignal {
        string sanctumID;
        string clauseID;
        bool recoveryConfirmed;
        string restorationType;
        uint256 timestamp;
    }

    RecoverySignal[] public signals;

    event RecoveryEmitted(string sanctumID, string clauseID, bool recoveryConfirmed, string restorationType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitRecovery(string memory sanctumID, string memory clauseID, bool recoveryConfirmed, string memory restorationType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(RecoverySignal(sanctumID, clauseID, recoveryConfirmed, restorationType, block.timestamp));
        emit RecoveryEmitted(sanctumID, clauseID, recoveryConfirmed, restorationType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        RecoverySignal memory s = signals[index];
        return (s.sanctumID, s.clauseID, s.recoveryConfirmed, s.restorationType, s.timestamp);
    }
}
