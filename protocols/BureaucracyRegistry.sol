// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BureaucracyRegistry: record bureaucratic delays and requirements
contract BureaucracyRegistry {
    struct Delay {
        uint256 id;
        string agency;
        string requirement;
        string status;      // "Incomplete", "Processing", "Cut-Off"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Delay) public delays;
    mapping(address => bool) public stewards;

    event DelayLogged(uint256 indexed id, string agency, string requirement, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logDelay(string calldata agency, string calldata requirement, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        delays[nextId] = Delay(nextId, agency, requirement, status, block.timestamp);
        emit DelayLogged(nextId, agency, requirement, status);
        nextId++;
    }
}
