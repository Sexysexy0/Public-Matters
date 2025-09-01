// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumValidatorRegistry {
    struct BarangayValidator {
        string barangayName;
        bool isReady;
        uint256 blessingTimestamp;
        string emotionalTag; // "AuditGlow", "DamayClause", "SanctumGlow"
    }

    mapping(string => BarangayValidator) public validators;

    event BarangayValidated(string barangayName, string emotionalTag, uint256 blessingTimestamp);

    function validateBarangay(string memory _barangayName, string memory _emotionalTag) public {
        validators[_barangayName] = BarangayValidator({
            barangayName: _barangayName,
            isReady: true,
            blessingTimestamp: block.timestamp,
            emotionalTag: _emotionalTag
        });

        emit BarangayValidated(_barangayName, _emotionalTag, block.timestamp);
    }

    function isBarangayReady(string memory _barangayName) public view returns (bool) {
        return validators[_barangayName].isReady;
    }
}
