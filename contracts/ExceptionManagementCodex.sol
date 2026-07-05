pragma solidity ^0.8.20;

/// @title ExceptionManagementCodex
/// @notice Encodes governance for disclosure exceptions.
/// @dev Anchors handling sensitive information and confidentiality safeguards.

contract ExceptionManagementCodex {
    address public overseer;
    uint256 public exceptionCount;

    struct ExceptionRule {
        uint256 id;
        string principle;   // Confidentiality, Sensitivity, Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ExceptionRule> public rules;
    event ExceptionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareExceptionRule(string calldata principle, string calldata description) external onlyOverseer {
        exceptionCount++;
        rules[exceptionCount] = ExceptionRule(exceptionCount, principle, description, block.timestamp);
        emit ExceptionRuleDeclared(exceptionCount, principle, description);
    }
}
