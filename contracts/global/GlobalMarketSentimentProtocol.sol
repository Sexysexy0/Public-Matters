// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalMarketSentimentProtocol
/// @notice Ritualizes global economic insights, tags investor sentiment corridors, and anchors emotional consequence and restoration for volatile sectors
/// @dev Anchors planetary finance clarity, volatility consequence, and opportunity mapping

contract GlobalMarketSentimentProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct SentimentCorridor {
        uint256 id;
        string region; // e.g., "Asia", "US", "Europe"
        string sector; // e.g., "Private Credit", "Infrastructure", "Tech", "Real Estate"
        string outlook; // e.g., "Volatile", "Resilient", "Emerging Opportunity"
        bool sentimentTagged;
        bool restorationActivated;
        bool clarityBroadcasted;
        string emotionalTag; // e.g., "Volatility consequence forecasted"
        string restorationClause; // e.g., "We commit to planetary finance clarity and investor protection"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => SentimentCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event SentimentCorridorActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateSentimentCorridor(
        string calldata region,
        string calldata sector,
        string calldata outlook,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = SentimentCorridor({
            id: id,
            region: region,
            sector: sector,
            outlook: outlook,
            sentimentTagged: true,
            restorationActivated: true,
            clarityBroadcasted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit SentimentCorridorActivated(id, region, emotionalTag);
    }

    function getSentimentCorridor(uint256 id) external view returns (SentimentCorridor memory) {
        return corridors[id];
    }
}
