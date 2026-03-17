// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UpgradeManager {
    mapping(string => address) public versions;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setVersion(string memory name, address contractAddress) public {
        require(msg.sender == owner, "Only owner can set version");
        versions[name] = contractAddress;
    }

    function getVersion(string memory name) public view returns (address) {
        return versions[name];
    }
}
