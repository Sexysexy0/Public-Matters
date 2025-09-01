// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SignatureVerifier {
    event SignatureLogged(
        address signer,
        string documentHash,
        string role,
        bool verified,
        uint256 timestamp
    );

    struct SignatureRecord {
        address signer;
        string documentHash;
        string role;
        bool verified;
        uint256 timestamp;
    }

    mapping(bytes32 => SignatureRecord) public signatures;

    function logSignature(
        address signer,
        string memory documentHash,
        string memory role,
        bool verified
    ) external {
        bytes32 sigId = keccak256(abi.encodePacked(signer, documentHash, block.timestamp));
        signatures[sigId] = SignatureRecord(signer, documentHash, role, verified, block.timestamp);
        emit SignatureLogged(signer, documentHash, role, verified, block.timestamp);
    }

    function getSignature(bytes32 sigId) external view returns (SignatureRecord memory) {
        return signatures[sigId];
    }
}
