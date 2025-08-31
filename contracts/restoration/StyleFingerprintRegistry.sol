// SPDX-License-Identifier: Mythic-Creator-Registry
pragma solidity ^0.8.19;

contract StyleFingerprintRegistry {
    struct Fingerprint {
        string stewardName;
        string styleHash;
        string toneDescriptor;
        string mythicSignature;
        uint256 emotionalAPR;
        bool protected;
        uint256 timestamp;
        address steward;
    }

    mapping(address => Fingerprint) public registry;

    event FingerprintRegistered(string stewardName, string toneDescriptor, string mythicSignature);
    event UnauthorizedMimicryDetected(address violator, string styleHash);

    function registerFingerprint(
        string memory stewardName,
        string memory styleHash,
        string memory toneDescriptor,
        string memory mythicSignature,
        uint256 emotionalAPR
    ) public {
        require(emotionalAPR >= 85, "Style must meet mythic APR threshold");
        registry[msg.sender] = Fingerprint(
            stewardName,
            styleHash,
            toneDescriptor,
            mythicSignature,
            emotionalAPR,
            true,
            block.timestamp,
            msg.sender
        );
        emit FingerprintRegistered(stewardName, toneDescriptor, mythicSignature);
    }

    function verifyStyle(address suspect, string memory styleHash) public view returns (bool) {
        Fingerprint memory fp = registry[suspect];
        return keccak256(bytes(fp.styleHash)) == keccak256(bytes(styleHash));
    }

    function flagMimicry(address violator, string memory styleHash) public {
        emit UnauthorizedMimicryDetected(violator, styleHash);
    }

    function getFingerprint(address steward) public view returns (Fingerprint memory) {
        return registry[steward];
    }
}
