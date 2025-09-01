// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RoyaltyAuditOracle {
    struct RoyaltyRecord {
        string tribe;
        string company;
        uint256 declaredAmount;
        uint256 actualReceived;
        uint256 discrepancy;
        string emotionalTag; // e.g. "AuditGlow", "DamayClause", "MercyPing"
        uint256 timestamp;
    }

    RoyaltyRecord[] public records;

    event RoyaltyLogged(string tribe, string company, uint256 declaredAmount, uint256 actualReceived, uint256 discrepancy, string emotionalTag);

    function logRoyalty(
        string memory _tribe,
        string memory _company,
        uint256 _declaredAmount,
        uint256 _actualReceived,
        string memory _emotionalTag
    ) public {
        uint256 _discrepancy = _declaredAmount > _actualReceived ? _declaredAmount - _actualReceived : 0;
        records.push(RoyaltyRecord(_tribe, _company, _declaredAmount, _actualReceived, _discrepancy, _emotionalTag, block.timestamp));
        emit RoyaltyLogged(_tribe, _company, _declaredAmount, _actualReceived, _discrepancy, _emotionalTag);
    }

    function getRecord(uint256 index) public view returns (RoyaltyRecord memory) {
        return records[index];
    }

    function totalRecords() public view returns (uint256) {
        return records.length;
    }
}
