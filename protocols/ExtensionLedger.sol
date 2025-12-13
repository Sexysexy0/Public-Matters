// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ExtensionLedger: record proposed railway extensions
contract ExtensionLedger {
    struct Extension {
        uint256 id;
        string route;       // "Calamba-Naga", "Naga-Legazpi", "Visayas-Mindanao"
        uint256 distance;   // kilometers
        bool proposed;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Extension) public extensions;
    mapping(address => bool) public stewards;

    event ExtensionLogged(uint256 indexed id, string route, uint256 distance);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logExtension(string calldata route, uint256 distance, bool proposed) external {
        require(stewards[msg.sender], "Only steward");
        extensions[nextId] = Extension(nextId, route, distance, proposed, block.timestamp);
        emit ExtensionLogged(nextId, route, distance);
        nextId++;
    }
}
