pragma solidity ^0.8.20;

/// @title GlobalMcCormickLedger
/// @notice Encodes international collaboration strategies.
/// @dev Anchors leveraging Northwestern’s global ties and partnerships.

contract GlobalMcCormickLedger {
    address public overseer;
    uint256 public entryCount;

    struct Collaboration {
        uint256 id;
        string principle;   // International, Partnership, Global
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Collaboration> public collaborations;
    event CollaborationDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCollaboration(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        collaborations[entryCount] = Collaboration(entryCount, principle, description, block.timestamp);
        emit CollaborationDeclared(entryCount, principle, description);
    }
}
