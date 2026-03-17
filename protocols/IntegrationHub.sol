// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntegrationHub {
    mapping(string => address) public registry;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function registerContract(string memory name, address contractAddress) public {
        require(msg.sender == owner, "Only owner can register");
        registry[name] = contractAddress;
    }

    function getContract(string memory name) public view returns (address) {
        return registry[name];
    }
}
