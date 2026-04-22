// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title SovereignSignatures
 * @dev Manages verified signatures to prove ownership and consensus without intermediaries.
 */
contract SovereignSignatures {
    using ECDSA for bytes32;

    address public immutable sovereign;
    mapping(bytes32 => bool) public verifiedClaims;

    constructor() {
        sovereign = msg.sender; // Vin's address is the ultimate authority
    }

    // [Goal: Verify a claim based on a cryptographic signature]
    function verifyLegalClaim(
        bytes32 _claimHash, 
        bytes memory _signature
    ) external {
        address signer = _claimHash.toEthSignedMessageHash().recover(_signature);
        require(signer == sovereign, "ERROR: Unauthorized signature. Claim rejected.");
        
        verifiedClaims[_claimHash] = true;
    }

    function isClaimPermanent(bytes32 _claimHash) external view returns (string memory) {
        if (verifiedClaims[_claimHash]) {
            return "VERIFIED: This claim is backed by the Sovereign. It cannot be 'Shut Down' by external parties.";
        }
        return "PENDING: Awaiting Sovereign validation.";
    }
}
