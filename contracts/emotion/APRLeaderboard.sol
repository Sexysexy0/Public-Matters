// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract APRLeaderboard {
    struct VendorAPR {
        string name;
        uint256 empathy;
        uint256 trust;
        uint256 mythicClarity;
        uint256 totalScore;
    }

    VendorAPR[] public leaderboard;

    event VendorRanked(string name, uint256 totalScore);

    function submitAPR(
        string memory _name,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        uint256 score = _empathy + _trust + _clarity;
        leaderboard.push(VendorAPR(_name, _empathy, _trust, _clarity, score));
        emit VendorRanked(_name, score);
    }

    function getLeaderboard() public view returns (VendorAPR[] memory) {
        return leaderboard;
    }
}
