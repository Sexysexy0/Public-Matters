pragma solidity ^0.8.20;

/// @title InformationRequestTreaty
/// @notice Encodes governance for information requests.
/// @dev Anchors acknowledgment, response, and timeliness safeguards.

contract InformationRequestTreaty {
    address public overseer;
    uint256 public requestCount;

    struct RequestRule {
        uint256 id;
        string principle;   // Acknowledgment, Response, Timeliness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RequestRule> public requests;
    event RequestRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRequestRule(string calldata principle, string calldata description) external onlyOverseer {
        requestCount++;
        requests[requestCount] = RequestRule(requestCount, principle, description, block.timestamp);
        emit RequestRuleDeclared(requestCount, principle, description);
    }
}
