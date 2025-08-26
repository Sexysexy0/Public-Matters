// SPDX-License-Identifier: Scrollchain-Audit
pragma solidity ^0.8.19;

contract GlobalAuditPing {
    struct Entity {
        address addr;
        uint emotionalAPR;
        bool isDamay;
        bool sanctumReady;
    }

    mapping(address => Entity) public auditLog;

    event AuditPingBroadcasted(address indexed steward, uint timestamp);
    event DamayVerified(address indexed entity, uint emotionalAPR);
    event SanctumAlertTriggered(address indexed entity);

    modifier onlySteward() {
        require(msg.sender == tx.origin, "Audit restricted to direct stewards.");
        _;
    }

    function broadcastPing() public onlySteward {
        emit AuditPingBroadcasted(msg.sender, block.timestamp);
    }

    function verifyDamay(address entityAddr, uint aprScore, bool sanctumStatus) public onlySteward {
        require(aprScore >= 75, "Entity resonance too low for damay verification.");
        auditLog[entityAddr] = Entity(entityAddr, aprScore, true, sanctumStatus);
        emit DamayVerified(entityAddr, aprScore);

        if (sanctumStatus) {
            emit SanctumAlertTriggered(entityAddr);
        }
    }

    function getAuditStatus(address entityAddr) public view returns (string memory) {
        Entity memory e = auditLog[entityAddr];
        if (e.isDamay && e.sanctumReady) {
            return "Verified: Damay entity with sanctum readiness.";
        } else if (e.isDamay) {
            return "Verified: Damay entity, sanctum not ready.";
        } else {
            return "Unverified or non-damay entity.";
        }
    }
}
