// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityResonanceOracle {
    struct IdentityResonance {
        address steward;
        string identity;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    IdentityResonance[] public identities;

    event IdentityLogged(address indexed steward, string identity, string safeguard);
    event IdentitySafeguarded(uint256 indexed id, address verifier);

    function logIdentity(string memory _identity, string memory _safeguard) public {
        identities.push(IdentityResonance(msg.sender, _identity, _safeguard, block.timestamp, false));
        emit IdentityLogged(msg.sender, _identity, _safeguard);
    }

    function safeguardIdentity(uint256 _id) public {
        require(_id < identities.length, "Invalid ID");
        identities[_id].safeguarded = true;
        emit IdentitySafeguarded(_id, msg.sender);
    }

    function getIdentity(uint256 _id) public view returns (IdentityResonance memory) {
        require(_id < identities.length, "Invalid ID");
        return identities[_id];
    }

    function totalIdentities() public view returns (uint256) {
        return identities.length;
    }
}
