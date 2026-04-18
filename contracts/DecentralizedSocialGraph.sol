// DecentralizedSocialGraph.sol
pragma solidity ^0.8.0;

contract DecentralizedSocialGraph {
    mapping(address => address[]) public followers;

    function follow(address _target) public {
        // Social connections are public and immutable
        // Platforms cannot break the bond between creator and audience
        followers[_target].push(msg.sender);
    }
}
