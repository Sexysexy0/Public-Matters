// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WhaleSignal
/// @notice Safeguard contract for whale exits and market sentiment
/// @dev Encodes whale transactions, signal effects, and sentiment audits

contract WhaleSignal {
    address public steward;
    uint256 public exitCount;
    uint256 public signalCount;
    uint256 public sentimentCount;

    struct WhaleExit {
        uint256 id;
        string actor;       // e.g., "Institutional Whale", "Retail Whale"
        uint256 amount;     // in BTC or USD equivalent
        uint256 timestamp;
    }

    struct SignalEffect {
        uint256 id;
        string trigger;     // e.g., "Saylor Sale", "Headline Drop"
        string impact;      // e.g., "Market Fear", "Narrative Shock"
        uint256 timestamp;
    }

    struct SentimentAudit {
        uint256 id;
        string mood;        // e.g., "Fear", "Greed", "Vertigo"
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WhaleExit) public exits;
    mapping(uint256 => SignalEffect) public signals;
    mapping(uint256 => SentimentAudit) public sentiments;

    event ExitLogged(uint256 id, string actor, uint256 amount, uint256 timestamp);
    event SignalLogged(uint256 id, string trigger, string impact, uint256 timestamp);
    event SentimentLogged(uint256 id, string mood, string description, uint256 timestamp);
    event MarketCheck(string report, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
        exitCount = 0;
        signalCount = 0;
        sentimentCount = 0;
    }

    /// @notice Log a whale exit
    function logExit(string calldata actor, uint256 amount) external onlySteward {
        exitCount++;
        exits[exitCount] = WhaleExit(exitCount, actor, amount, block.timestamp);
        emit ExitLogged(exitCount, actor, amount, block.timestamp);
    }

    /// @notice Log a signal effect
    function logSignal(string calldata trigger, string calldata impact) external onlySteward {
        signalCount++;
        signals[signalCount] = SignalEffect(signalCount, trigger, impact, block.timestamp);
        emit SignalLogged(signalCount, trigger, impact, block.timestamp);
    }

    /// @notice Log a sentiment audit
    function logSentiment(string calldata mood, string calldata description) external onlySteward {
        sentimentCount++;
        sentiments[sentimentCount] = SentimentAudit(sentimentCount, mood, description, block.timestamp);
        emit SentimentLogged(sentimentCount, mood, description, block.timestamp);
    }

    /// @notice Market narrative check
    function logMarketCheck(string calldata report) external onlySteward {
        emit MarketCheck(report, block.timestamp);
    }
}
