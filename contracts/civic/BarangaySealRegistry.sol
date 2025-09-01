// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangaySealRegistry {
    struct BarangaySeal {
        string barangayName;
        string validatorName;
        string sealHash; // IPFS or hash of seal image
        string emotionalTag; // "SanctumGlow", "AuditGlow", "BlessingPulse"
        uint256 sealTimestamp;
        bool isActive;
    }

    mapping(string => BarangaySeal) public seals;

    event SealRegistered(string barangayName, string validatorName, string emotionalTag, uint256 sealTimestamp);

    function registerSeal(
        string memory _barangayName,
        string memory _validatorName,
        string memory _sealHash,
        string memory _emotionalTag
    ) public {
        seals[_barangayName] = BarangaySeal({
            barangayName: _barangayName,
            validatorName: _validatorName,
            sealHash: _sealHash,
            emotionalTag: _emotionalTag,
            sealTimestamp: block.timestamp,
            isActive: true
        });

        emit SealRegistered(_barangayName, _validatorName, _emotionalTag, block.timestamp);
    }

    function deactivateSeal(string memory _barangayName) public {
        seals[_barangayName].isActive = false;
    }

    function getSealDetails(string memory _barangayName) public view returns (BarangaySeal memory) {
        return seals[_barangayName];
    }
}
