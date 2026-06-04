// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlanetaryEthics
/// @notice Covenant contract to embed universal ethical anchors into planetary resilience
contract PlanetaryEthics {
    address public owner;

    struct Anchor {
        string principle;    // e.g. "Justice", "Compassion", "Stewardship", "Solidarity"
        string origin;       // e.g. "Faith", "Philosophy", "Community Charter"
        string application;  // how it applies to planetary governance
        uint256 timestamp;
    }

    Anchor[] public anchors;

    event AnchorLogged(string principle, string origin, string application, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new universal ethical anchor
    function logAnchor(string memory principle, string memory origin, string memory application) public onlyOwner {
        Anchor memory newAnchor = Anchor(principle, origin, application, block.timestamp);
        anchors.push(newAnchor);
        emit AnchorLogged(principle, origin, application, block.timestamp);
    }

    function getAnchor(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        Anchor memory a = anchors[index];
        return (a.principle, a.origin, a.application, a.timestamp);
    }

    function getAnchorCount() public view returns (uint256) {
        return anchors.length;
    }
}
