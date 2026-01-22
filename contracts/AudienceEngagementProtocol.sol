pragma solidity ^0.8.20;

contract AudienceEngagementProtocol {
    address public admin;

    struct Engagement {
        string teaching;     // e.g. Taxes to Caesar
        string method;       // e.g. reframing, parable, counter-question
        string effect;       // e.g. audience reflection, deeper spiritual insight
        uint256 timestamp;
    }

    Engagement[] public engagements;

    event EngagementLogged(string teaching, string method, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEngagement(string calldata teaching, string calldata method, string calldata effect) external onlyAdmin {
        engagements.push(Engagement(teaching, method, effect, block.timestamp));
        emit EngagementLogged(teaching, method, effect, block.timestamp);
    }

    function totalEngagements() external view returns (uint256) {
        return engagements.length;
    }
}
