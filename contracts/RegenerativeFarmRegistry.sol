// RegenerativeFarmRegistry.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RegenerativeFarmRegistry is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Farm {
        address owner;
        uint256 soilOrganicMatter; // Primary health metric
        bool isRegenerative;
    }

    mapping(address => Farm) public farmers;

    function certifyFarm(uint256 _soilHealth) public {
        if (_soilHealth >= 5) { // 5% organic matter threshold
            farmers[msg.sender].isRegenerative = true;
            // Logic: Unlock access to zero-interest green loans
        }
    }
}
