// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AntiGagProtocol {
    struct TruthDefense {
        bytes32 contentHash;
        bool isPublicInterest;
        bool hasEvidence;
    }

    mapping(bytes32 => TruthDefense) public defenseVault;

    // Kung ang content ay totoo (Truth is Absolute Defense)
    // Ang system na ito ang magbibigay ng "Immunity Token" sa journalist
    function registerDefense(bytes32 _contentHash, bool _evidence) public {
        defenseVault[_contentHash] = TruthDefense({
            contentHash: _contentHash,
            isPublicInterest: true,
            hasEvidence: _evidence
        });
    }

    function checkImmunity(bytes32 _contentHash) public view returns (string memory) {
        if(defenseVault[_contentHash].hasEvidence) {
            return "IMMUNITY GRANTED: Content is in Public Interest and Factually Supported.";
        }
        return "PENDING AUDIT.";
    }
}
