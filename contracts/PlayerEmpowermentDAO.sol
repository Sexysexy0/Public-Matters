pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PlayerEmpowermentDAO is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public votes;

    event OptimizationDemand(string game, uint256 totalVotes);

    function voteForOptimization(string memory game) public {
        votes[msg.sender] += 1;
        emit OptimizationDemand(game, votes[msg.sender]);
    }
}
