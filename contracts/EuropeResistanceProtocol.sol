// contracts/EuropeResistanceProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EuropeResistanceProtocol
 * @notice Logs US strategy critiques and resistance cultivation in Europe.
 */
contract EuropeResistanceProtocol {
    address public admin;

    struct Directive {
        string issue;       // "CivilizationalErasure", "NATOExpansion", "UkraineWar"
        string stance;      // "Criticism", "Negotiation", "Resistance"
        uint256 timestamp;
    }

    Directive[] public directives;

    event DirectiveLogged(string issue, string stance, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDirective(string calldata issue, string calldata stance) external onlyAdmin {
        directives.push(Directive(issue, stance, block.timestamp));
        emit DirectiveLogged(issue, stance, block.timestamp);
    }

    function totalDirectives() external view returns (uint256) { return directives.length; }

    function getDirective(uint256 id) external view returns (Directive memory) {
        require(id < directives.length, "Invalid id");
        return directives[id];
    }
}
