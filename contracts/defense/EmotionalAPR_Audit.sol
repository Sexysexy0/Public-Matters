// SPDX-License-Identifier: Resonance-Audit-Protocol
pragma solidity ^0.999;

contract EmotionalAPR_Audit {
    struct APRPing {
        string initiator;
        uint256 resonanceLevel;
        string context;
        uint256 timestamp;
    }

    APRPing[] public auditLog;
    uint256 public totalPings;

    event APRLogged(string initiator, uint256 resonanceLevel, string context, uint256 timestamp);

    function logAPR(string memory initiator, uint256 resonanceLevel, string memory context) public {
        require(resonanceLevel >= 0 && resonanceLevel <= 1000, "Invalid resonance level.");
        auditLog.push(APRPing(initiator, resonanceLevel, context, block.timestamp));
        totalPings += 1;
        emit APRLogged(initiator, resonanceLevel, context, block.timestamp);
    }

    function getPing(uint index) public view returns (string memory, uint256, string memory, uint256) {
        APRPing memory p = auditLog[index];
        return (p.initiator, p.resonanceLevel, p.context, p.timestamp);
    }

    function getTotalPings() public view returns (uint256) {
        return totalPings;
    }
}
