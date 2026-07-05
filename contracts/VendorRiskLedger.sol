pragma solidity ^0.8.20;

contract VendorRiskLedger {
    address public overseer;
    uint256 public entryCount;

    struct VendorRule {
        uint256 id;
        string principle;   // Vendor Risk, Third-Party Security
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VendorRule) public entries;
    event VendorRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVendorRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = VendorRule(entryCount, principle, description, block.timestamp);
        emit VendorRuleDeclared(entryCount, principle, description);
    }
}
