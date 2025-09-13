// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationEquityRouter {
    enum BarrierType { Poverty, Disability, ConflictZone, EarlyPregnancy }
    enum ShieldType { ALSEnrollment, ConditionalCashTransfer, SchoolInABag, Counseling }

    struct EquityBlessing {
        uint256 id;
        BarrierType barrierType;
        ShieldType shieldType;
        string schoolTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => EquityBlessing) public equityRegistry;
    uint256 public equityCount;

    event BlessingLogged(uint256 id, BarrierType barrierType, ShieldType shieldType);
    event ShieldUpdated(uint256 id, ShieldType newShieldType);

    function logBlessing(
        BarrierType barrierType,
        ShieldType shieldType,
        string memory schoolTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        equityRegistry[equityCount] = EquityBlessing(
            equityCount,
            barrierType,
            shieldType,
            schoolTag,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(equityCount, barrierType, shieldType);
        equityCount++;
    }

    function updateShield(uint256 id, ShieldType newShieldType) public {
        require(id < equityCount, "Invalid blessing ID");
        equityRegistry[id].shieldType = newShieldType;
        emit ShieldUpdated(id, newShieldType);
    }

    function getEquityBlessing(uint256 id) public view returns (EquityBlessing memory) {
        return equityRegistry[id];
    }
}
