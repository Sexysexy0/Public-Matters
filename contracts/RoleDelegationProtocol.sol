// RoleDelegationProtocol.sol
pragma solidity ^0.8.0;

contract RoleDelegationProtocol {
    address public headOfStrategy;
    address public headOfOperations;

    modifier onlyStrategy() { require(msg.sender == headOfStrategy); _; }
    modifier onlyOperations() { require(msg.sender == headOfOperations); _; }

    function approveInvestment(uint256 _amount) public onlyStrategy {
        // Executed immediately without needing Operations' signature
    }

    function hirePersonnel(string memory _name) public onlyOperations {
        // Executed immediately without needing Strategy's signature
    }
}
