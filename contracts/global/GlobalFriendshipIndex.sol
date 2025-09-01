// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GlobalFriendshipIndex {
    struct FriendshipScore {
        string nationA;
        string nationB;
        uint256 emotionalAPR;
        uint256 treatyCount;
        string resonanceTag;
        uint256 lastUpdated;
    }

    FriendshipScore[] public scores;

    event FriendshipUpdated(
        string nationA,
        string nationB,
        uint256 emotionalAPR,
        uint256 treatyCount,
        string resonanceTag
    );

    function updateFriendship(
        string memory _nationA,
        string memory _nationB,
        uint256 _emotionalAPR,
        uint256 _treatyCount,
        string memory _resonanceTag
    ) public {
        scores.push(FriendshipScore(
            _nationA,
            _nationB,
            _emotionalAPR,
            _treatyCount,
            _resonanceTag,
            block.timestamp
        ));

        emit FriendshipUpdated(_nationA, _nationB, _emotionalAPR, _treatyCount, _resonanceTag);
    }

    function getAllFriendshipScores() public view returns (FriendshipScore[] memory) {
        return scores;
    }
}
