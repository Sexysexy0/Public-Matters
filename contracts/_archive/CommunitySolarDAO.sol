pragma solidity ^0.8.0;

contract CommunitySolarDAO {
    mapping(address => uint256) public votes;

    function voteForSolar(address voter) public {
        votes[voter] += 1;
    }
}
