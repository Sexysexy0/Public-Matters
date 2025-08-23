// SPDX-License-Identifier: Firewall-Blessing-License  
pragma solidity ^0.8.19;

contract FirewallBlessingProtocol {
    mapping(string => bool) public blessedSystems;

    event SystemBlessed(string systemName);

    function blessSystem(string memory systemName) public {
        blessedSystems[systemName] = true;
        emit SystemBlessed(systemName);
    }

    function isBlessed(string memory systemName) public view returns (bool) {
        return blessedSystems[systemName];
    }
}
