// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransmogIdentityVault {
    struct Identity {
        address player;
        string gearPiece;
        string style;
        uint256 timestamp;
        bool safeguarded;
    }

    Identity[] public identities;

    event IdentityLogged(address indexed player, string gearPiece, string style);
    event IdentitySafeguarded(uint256 indexed id, address verifier);

    function logIdentity(string memory _gearPiece, string memory _style) public {
        identities.push(Identity(msg.sender, _gearPiece, _style, block.timestamp, false));
        emit IdentityLogged(msg.sender, _gearPiece, _style);
    }

    function safeguardIdentity(uint256 _id) public {
        require(_id < identities.length, "Invalid ID");
        identities[_id].safeguarded = true;
        emit IdentitySafeguarded(_id, msg.sender);
    }

    function getIdentity(uint256 _id) public view returns (Identity memory) {
        require(_id < identities.length, "Invalid ID");
        return identities[_id];
    }

    function totalIdentities() public view returns (uint256) {
        return identities.length;
    }
}
