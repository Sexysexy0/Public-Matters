pragma solidity ^0.8.0;

contract PlayerEmpowermentDAO {
    mapping(address => uint256) public votes;

    event OptimizationDemand(string game, uint256 totalVotes);

    function voteForOptimization(string memory game) public {
        votes[msg.sender] += 1;
        emit OptimizationDemand(game, votes[msg.sender]);
    }
}
