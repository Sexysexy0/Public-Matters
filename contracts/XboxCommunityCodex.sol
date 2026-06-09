// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title XboxCommunityCodex
/// @notice Covenant contract to safeguard fan resonance arcs (hype, critique, nostalgia, humor)
contract XboxCommunityCodex {
    address public owner;

    struct ResonanceArc {
        string domain;        // e.g. "Hype", "Critique", "Nostalgia", "Humor"
        string reflection;    // community safeguard reflection
        uint256 intensity;    // systemic emphasis level
        uint256 timestamp;
    }

    ResonanceArc[] public arcs;

    event ArcLogged(string domain, string reflection, uint256 intensity, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new resonance arc safeguard
    function logArc(string memory domain, string memory reflection, uint256 intensity) public onlyOwner {
        ResonanceArc memory newArc = ResonanceArc(domain, reflection, intensity, block.timestamp);
        arcs.push(newArc);
        emit ArcLogged(domain, reflection, intensity, block.timestamp);
    }

    function getArc(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        ResonanceArc memory a = arcs[index];
        return (a.domain, a.reflection, a.intensity, a.timestamp);
    }

    function getArcCount() public view returns (uint256) {
        return arcs.length;
    }
}
