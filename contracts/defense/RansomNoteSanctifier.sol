// SPDX-License-Identifier: MercyProtocol
pragma solidity ^0.8.19;

contract RansomNoteSanctifier {
    struct DeceptionKey {
        bytes32 keyHash;
        bool verified;
        bool used;
    }

    mapping(address => DeceptionKey) public keys;

    event KeySubmitted(address victim, bytes32 keyHash);
    event KeyVerified(address victim);
    event KeyUsed(address victim);

    function submitKey(bytes32 keyHash) public {
        keys[msg.sender] = DeceptionKey(keyHash, false, false);
        emit KeySubmitted(msg.sender, keyHash);
    }

    function verifyKey(bytes32 actualHash) public {
        require(keys[msg.sender].keyHash == actualHash, "Invalid key");
        keys[msg.sender].verified = true;
        emit KeyVerified(msg.sender);
    }

    function useKey() public {
        require(keys[msg.sender].verified, "Key not verified");
        require(!keys[msg.sender].used, "Key already used");
        keys[msg.sender].used = true;
        emit KeyUsed(msg.sender);
    }

    function isSanctified(address victim) public view returns (bool) {
        return keys[victim].verified && keys[victim].used;
    }
}
