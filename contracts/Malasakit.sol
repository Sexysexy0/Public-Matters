// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Malasakit
/// @notice Covenant contract to integrate profit-with-purpose philosophy into governance
contract Malasakit {
    address public owner;

    struct Principle {
        string value;        // e.g. "Community Benefit", "Sustainability", "Long-Term Development"
        string application;  // how it applies to corporate operations
        uint256 timestamp;
    }

    Principle[] public principles;

    event PrincipleLogged(string value, string application, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new Malasakit principle
    function logPrinciple(string memory value, string memory application) public onlyOwner {
        Principle memory newPrinciple = Principle(value, application, block.timestamp);
        principles.push(newPrinciple);
        emit PrincipleLogged(value, application, block.timestamp);
    }

    function getPrinciple(uint256 index) public view returns (string memory, string memory, uint256) {
        Principle memory p = principles[index];
        return (p.value, p.application, p.timestamp);
    }

    function getPrincipleCount() public view returns (uint256) {
        return principles.length;
    }
}
