// DecentralizedSocialGraph.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedSocialGraph is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => address[]) public followers;

    function follow(address _target) public {
        // Social connections are public and immutable
        // Platforms cannot break the bond between creator and audience
        followers[_target].push(msg.sender);
    }
}
