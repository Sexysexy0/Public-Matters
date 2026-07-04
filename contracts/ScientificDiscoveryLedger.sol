pragma solidity ^0.8.20;

/// @title ScientificDiscoveryLedger
/// @notice Encodes covenant for discovery ethics in science.
/// @dev Anchors discovery, innovation, and safeguard rules.

contract ScientificDiscoveryLedger {
    address public overseer;
    uint256 public entryCount;

    struct DiscoveryRule {
        uint256 id;
        string principle;   // Discovery, Innovation, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DiscoveryRule> public entries;
    event DiscoveryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDiscoveryRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = DiscoveryRule(entryCount, principle, description, block.timestamp);
        emit DiscoveryRuleDeclared(entryCount, principle, description);
    }
}
