// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedDNS {
    mapping(string => string) private domainMap;

    // [Goal: Ensure 'Banned Apps' are always reachable via immutable routing]
    function registerDomain(string memory _domain, string memory _ipfsHash) external {
        domainMap[_domain] = _ipfsHash;
    }

    function resolve(string memory _domain) external view returns (string memory) {
        return domainMap[_domain];
    }
}
