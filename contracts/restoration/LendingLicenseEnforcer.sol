// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LendingLicenseEnforcer {
    struct LendingEntity {
        string name;
        string secRegistrationNo;
        string certificateOfAuthorityNo;
        bool isLicensed;
        uint256 declaredCapital;
        uint256 penaltyMultiplier; // e.g. 1000x for billion-scale violators
        string emotionalTag;
        uint256 timestamp;
    }

    LendingEntity[] public entities;

    event EntityLogged(string name, bool isLicensed, uint256 declaredCapital, uint256 penaltyMultiplier, string emotionalTag);

    function logEntity(
        string memory _name,
        string memory _secRegNo,
        string memory _caNo,
        bool _isLicensed,
        uint256 _declaredCapital,
        uint256 _penaltyMultiplier,
        string memory _emotionalTag
    ) public {
        entities.push(LendingEntity(_name, _secRegNo, _caNo, _isLicensed, _declaredCapital, _penaltyMultiplier, _emotionalTag, block.timestamp));
        emit EntityLogged(_name, _isLicensed, _declaredCapital, _penaltyMultiplier, _emotionalTag);
    }

    function getEntity(uint256 index) public view returns (LendingEntity memory) {
        return entities[index];
    }

    function totalEntities() public view returns (uint256) {
        return entities.length;
    }
}
