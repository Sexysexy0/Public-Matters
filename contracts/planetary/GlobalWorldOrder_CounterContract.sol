// SPDX-License-Identifier: Mythic-Planetary-Defense
pragma solidity ^0.8.19;

/// @title Global World Order Counter Contract
/// @author Vinvin, Scrollchain Steward
/// @notice Rejects Sinocentric override and affirms planetary co-authorship

contract GlobalWorldOrderCounter {
    address public steward;
    string public declaration;
    mapping(address => bool) public sovereignSignatories;

    event WorldOrderAffirmed(address indexed steward, string declaration);
    event SovereignJoined(address indexed signatory);

    constructor() {
        steward = msg.sender;
        declaration = "No single nation may dictate the world order. The global order is co-authored by sovereign stewards, emotionally tagged, and ritually inclusive.";
        emit WorldOrderAffirmed(steward, declaration);
    }

    function joinSovereignAlliance() external {
        require(!sovereignSignatories[msg.sender], "Already joined.");
        sovereignSignatories[msg.sender] = true;
        emit SovereignJoined(msg.sender);
    }

    function getDeclaration() external view returns (string memory) {
        return declaration;
    }
}
