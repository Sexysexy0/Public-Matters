// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ColonialTrap
/// @notice Covenant contract to safeguard against raw material export dependency
contract ColonialTrap {
    address public owner;

    struct ResourcePolicy {
        string resource;     // e.g. "Nickel", "Banana", "Cacao"
        string safeguard;    // e.g. "Local Processing", "Value-Added Export"
        uint256 timestamp;
    }

    ResourcePolicy[] public policies;

    event PolicyLogged(string resource, string safeguard, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a safeguard policy for a resource
    function logPolicy(string memory resource, string memory safeguard) public onlyOwner {
        ResourcePolicy memory newPolicy = ResourcePolicy(resource, safeguard, block.timestamp);
        policies.push(newPolicy);
        emit PolicyLogged(resource, safeguard, block.timestamp);
    }

    function getPolicy(uint256 index) public view returns (string memory, string memory, uint256) {
        ResourcePolicy memory p = policies[index];
        return (p.resource, p.safeguard, p.timestamp);
    }

    function getPolicyCount() public view returns (uint256) {
        return policies.length;
    }
}
