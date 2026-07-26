// ComfortBuffEngine.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ComfortBuffEngine is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public comfortLevel;

    function applyDecoration(string memory _itemType) public {
        // Logic: Adding furniture/decorations increases 'Comfort' [54:05]
        // Encourages 'Build Mode' exploration and creativity
        comfortLevel[msg.sender] += 10;
    }
}
