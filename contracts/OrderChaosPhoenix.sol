// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OrderChaosPhoenix
/// @notice Covenant contract encoding mythological substructure of existence: Order, Chaos, Phoenix regeneration
contract OrderChaosPhoenix {
    address public owner;

    struct Arc {
        uint256 stageId;   // linked to transformation stage
        string domain;     // e.g. "Explored Territory", "Unknown Chaos", "Reconstituted Order", "Phoenix Regeneration"
        string decree;     // safeguard decree text
        uint256 timestamp;
    }

    Arc[] public arcs;

    event Engaged(uint256 stageId, string domain, string decree, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode transformation stage into covenant arc
    function engageStage(uint256 stageId, string memory domain, string memory decree) public onlyOwner {
        Arc memory newArc = Arc(stageId, domain, decree, block.timestamp);
        arcs.push(newArc);
        emit Engaged(stageId, domain, decree, block.timestamp);
    }

    function getArc(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Arc memory a = arcs[index];
        return (a.stageId, a.domain, a.decree, a.timestamp);
    }

    function getArcCount() public view returns (uint256) {
        return arcs.length;
    }
}
