// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CulturalAuthenticityCovenant {
    struct Likeness {
        address claimant;
        string entity;
        uint256 timestamp;
        bool safeguarded;
    }

    Likeness[] public likenesses;

    event LikenessLogged(address indexed claimant, string entity);
    event LikenessSafeguarded(uint256 indexed id, address verifier);

    function logLikeness(string memory _entity) public {
        likenesses.push(Likeness(msg.sender, _entity, block.timestamp, false));
        emit LikenessLogged(msg.sender, _entity);
    }

    function safeguardLikeness(uint256 _id) public {
        require(_id < likenesses.length, "Invalid ID");
        likenesses[_id].safeguarded = true;
        emit LikenessSafeguarded(_id, msg.sender);
    }

    function getLikeness(uint256 _id) public view returns (Likeness memory) {
        require(_id < likenesses.length, "Invalid ID");
        return likenesses[_id];
    }

    function totalLikenesses() public view returns (uint256) {
        return likenesses.length;
    }
}
