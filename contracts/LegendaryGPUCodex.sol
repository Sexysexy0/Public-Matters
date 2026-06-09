// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LegendaryGPUCodex
/// @notice Covenant contract to safeguard Pascal legacy, GOAT recognition, and community resonance
contract LegendaryGPUCodex {
    address public owner;

    struct GPURecord {
        string model;        // e.g. "GTX 1080 Ti", "RTX 4090"
        string safeguard;    // reflection safeguard (legacy, GOAT, resonance)
        uint256 weight;      // systemic emphasis level
        uint256 timestamp;
    }

    GPURecord[] public records;

    event GPULogged(string model, string safeguard, uint256 weight, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new GPU safeguard
    function logGPU(string memory model, string memory safeguard, uint256 weight) public onlyOwner {
        GPURecord memory newRecord = GPURecord(model, safeguard, weight, block.timestamp);
        records.push(newRecord);
        emit GPULogged(model, safeguard, weight, block.timestamp);
    }

    function getGPU(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        GPURecord memory g = records[index];
        return (g.model, g.safeguard, g.weight, g.timestamp);
    }

    function getGPUCount() public view returns (uint256) {
        return records.length;
    }
}
