// RoleBasedUtility.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RoleBasedUtility is Ownable {

    constructor() Ownable(msg.sender) {}

    // Nagbibigay ng unique perks sa mag-jowa
    function assignRoles(address _p1, address _p2) public {
        // Player 1: Combat & Exploration
        // Player 2: Crafting & Ship Management
    }
}
