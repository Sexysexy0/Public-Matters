// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title PriceIntegrityProtocol
/// @notice Tags suspicious liquidation cascades and maintains authenticity scores per exchange/asset
/// @dev Designed for stewardship: low-complexity heuristics, tunable thresholds, transparency via events
contract PriceIntegrityProtocol {
    // ---------- Roles ----------
    address public owner;
    mapping(address => bool) public stewards;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlySteward() {
        require(stewards[msg.sender] || msg.sender == owner, "Not steward");
        _;
    }

    // ---------- Types ----------
    struct ExchangeConfig {
        bool active;
        bool hasProofOfReserves;     // Exchange publishes verifiable PoR/PoL
        bool hasOnchainOrderbook;    // DEX or CEX with on-chain mirrors
        uint8 maxLeverageCap;        // Declared max leverage (e.g., 5, 10, 20)
        uint256 suspicionWindow;     // Time window for clustering, e.g., 30 minutes
        uint256 bigLiquidationUSD;   // Threshold for "big" liquidation, e.g., $100,000,000
        uint256 clusterThreshold;    // Count threshold within window to mark a cluster
        uint256 slippageThresholdBps;// e.g., 50 = 0.50% slippage threshold
    }

    struct AuthenticityScore {
        bool initialized;
        uint16 score;               // 0 - 100 (higher = more authentic)
        uint256 lastUpdated;
    }

    struct LiquidationEvent {
        bytes32 assetKey;           // keccak256("BTC"), etc.
        uint256 usdAmount;
        uint8 longsSharePct;        // e.g., 96 = 96% longs liquidated
        uint256 slippageBps;        // observed slippage in basis points
        uint256 timestamp;
    }

    // ---------- Storage ----------
    mapping(bytes32 => ExchangeConfig) public configs;                        // key: keccak256(exchangeName)
    mapping(bytes32 => mapping(bytes32 => AuthenticityScore)) public scores;  // exchange -> asset -> score
    mapping(bytes32 => LiquidationEvent[]) internal recentEvents;             // ring-buffer-like append

    uint256 public maxEventsPerExchange = 256; // to cap storage growth

    // ---------- Events ----------
    event StewardSet(address indexed account, bool status);
    event ExchangeConfigured(bytes32 indexed exKey, ExchangeConfig cfg);
    event LiquidationReported(
        bytes32 indexed exKey,
        bytes32 indexed assetKey,
        uint256 usdAmount,
        uint8 longsSharePct,
        uint256 slippageBps,
        uint256 timestamp
    );
    event SuspicionFlagged(
        bytes32 indexed exKey,
        bytes32 indexed assetKey,
        string reason,
        uint256 penalty
    );
    event AuthenticityScoreUpdated(
        bytes32 indexed exKey,
        bytes32 indexed assetKey,
        uint16 newScore
    );

    // ---------- Constructor ----------
    constructor() {
        owner = msg.sender;
        stewards[msg.sender] = true;
        emit StewardSet(msg.sender, true);
    }

    // ---------- Stewardship ----------
    function setSteward(address account, bool status) external onlyOwner {
        stewards[account] = status;
        emit StewardSet(account, status);
    }

    function setMaxEventsPerExchange(uint256 cap) external onlyOwner {
        require(cap >= 32 && cap <= 1024, "Cap out of range");
        maxEventsPerExchange = cap;
    }

    // ---------- Config ----------
    function setExchangeConfig(
        string memory exchangeName,
        ExchangeConfig memory cfg
    ) external onlySteward {
        require(cfg.maxLeverageCap <= 100, "Leverage too high");
        bytes32 exKey = _key(exchangeName);
        configs[exKey] = cfg;
        emit ExchangeConfigured(exKey, cfg);
    }

    // ---------- Reporting ----------
    /// @notice Report a liquidation event; triggers suspicion scoring and authenticity update
    /// @param exchangeName Identifier (e.g., "Binance", "Bybit", "GMX")
    /// @param assetSymbol  Identifier (e.g., "BTC", "ETH")
    /// @param usdAmount    Size of liquidation in USD terms
    /// @param longsSharePct Percentage of longs liquidated (0-100)
    /// @param slippageBps  Observed price slippage in basis points during event window
    function reportLiquidation(
        string memory exchangeName,
        string memory assetSymbol,
        uint256 usdAmount,
        uint8 longsSharePct,
        uint256 slippageBps
    ) external onlySteward {
        bytes32 exKey = _key(exchangeName);
        require(configs[exKey].active, "Exchange inactive");
        bytes32 assetKey = _key(assetSymbol);

        // Append to recent events (bounded)
        LiquidationEvent memory ev = LiquidationEvent({
            assetKey: assetKey,
            usdAmount: usdAmount,
            longsSharePct: longsSharePct,
            slippageBps: slippageBps,
            timestamp: block.timestamp
        });
        _appendEvent(exKey, ev);

        emit LiquidationReported(
            exKey,
            assetKey,
            usdAmount,
            longsSharePct,
            slippageBps,
            block.timestamp
        );

        // Compute suspicion + apply penalties
        (bool suspicious, string memory reason, uint256 penalty) = _evaluateSuspicion(exKey, ev);
        if (suspicious) {
            _applyPenalty(exKey, assetKey, penalty);
            emit SuspicionFlagged(exKey, assetKey, reason, penalty);
        } else {
            // small positive reinforcement
            _applyReward(exKey, assetKey, 1);
        }
    }

    // ---------- View ----------
    function getAuthenticityScore(string memory exchangeName, string memory assetSymbol)
        external
        view
        returns (uint16 score, uint256 lastUpdated)
    {
        bytes32 exKey = _key(exchangeName);
        bytes32 assetKey = _key(assetSymbol);
        AuthenticityScore memory s = scores[exKey][assetKey];
        return (s.initialized ? s.score : 80, s.lastUpdated);
    }

    function getRecentEvents(string memory exchangeName)
        external
        view
        returns (LiquidationEvent[] memory)
    {
        return recentEvents[_key(exchangeName)];
    }

    // ---------- Internal: Scoring ----------
    function _applyPenalty(bytes32 exKey, bytes32 assetKey, uint256 penalty) internal {
        AuthenticityScore storage s = scores[exKey][assetKey];
        if (!s.initialized) {
            s.initialized = true;
            s.score = 80; // default baseline
        }
        uint16 newScore = s.score > penalty ? uint16(s.score - penalty) : 0;
        s.score = newScore;
        s.lastUpdated = block.timestamp;
        emit AuthenticityScoreUpdated(exKey, assetKey, newScore);
    }

    function _applyReward(bytes32 exKey, bytes32 assetKey, uint256 reward) internal {
        AuthenticityScore storage s = scores[exKey][assetKey];
        if (!s.initialized) {
            s.initialized = true;
            s.score = 80;
        }
        uint16 newScore = s.score + reward > 100 ? 100 : uint16(s.score + reward);
        s.score = newScore;
        s.lastUpdated = block.timestamp;
        emit AuthenticityScoreUpdated(exKey, assetKey, newScore);
    }

    function _evaluateSuspicion(bytes32 exKey, LiquidationEvent memory ev)
        internal
        view
        returns (bool suspicious, string memory reason, uint256 penalty)
    {
        ExchangeConfig memory cfg = configs[exKey];

        // Heuristic flags
        bool bigWipe = ev.usdAmount >= cfg.bigLiquidationUSD;
        bool longSkew = ev.longsSharePct >= 85; // extreme long flush
        bool highSlip = ev.slippageBps >= cfg.slippageThresholdBps;
        bool weakControls = (!cfg.hasProofOfReserves) || (cfg.maxLeverageCap > 10);
        bool cluster = _countCluster(exKey, ev.timestamp, cfg.suspicionWindow) >= cfg.clusterThreshold;

        // Suspicion tiers -> additive penalty
        uint256 p;
        if (bigWipe) p += 10;
        if (longSkew) p += 8;
        if (highSlip) p += 6;
        if (weakControls) p += 8;
        if (cluster) p += 10;

        if (p >= 10) {
            // Build reason string (concise)
            string memory why = _reason(bigWipe, longSkew, highSlip, weakControls, cluster);
            return (true, why, p > 25 ? 25 : p); // cap penalty
        }
        return (false, "", 0);
    }

    function _countCluster(bytes32 exKey, uint256 nowTs, uint256 window)
        internal
        view
        returns (uint256 count)
    {
        LiquidationEvent[] memory arr = recentEvents[exKey];
        if (arr.length == 0) return 0;
        uint256 startTs = nowTs > window ? nowTs - window : 0;
        for (uint256 i = arr.length; i > 0; i--) {
            LiquidationEvent memory e = arr[i - 1];
            if (e.timestamp < startTs) break;
            count++;
        }
        return count;
    }

    function _reason(
        bool bigWipe,
        bool longSkew,
        bool highSlip,
        bool weakControls,
        bool cluster
    ) internal pure returns (string memory) {
        // Minimal concatenation to fit gas; prioritize clarity
        if (bigWipe && cluster && weakControls) return "Big wipe + cluster + weak controls";
        if (bigWipe && longSkew && highSlip) return "Big wipe + long skew + high slippage";
        if (cluster && longSkew) return "Clustered events + long skew";
        if (bigWipe && weakControls) return "Big wipe + weak controls";
        if (highSlip && weakControls) return "High slippage + weak controls";
        if (bigWipe) return "Big wipe";
        if (cluster) return "Clustered events";
        if (longSkew) return "Long skew";
        if (highSlip) return "High slippage";
        if (weakControls) return "Weak controls";
        return "Suspicious";
    }

    // ---------- Internal: Storage ----------
    function _appendEvent(bytes32 exKey, LiquidationEvent memory ev) internal {
        LiquidationEvent[] storage arr = recentEvents[exKey];
        arr.push(ev);
        if (arr.length > maxEventsPerExchange) {
            // Remove oldest by shifting head (costly); instead, pop and overwrite tail strategy:
            // Replace index 0 with last, then pop -> not time-ordered. We keep time order; so we soft-trim by deleting first 16.
            for (uint256 i = 0; i < 16 && arr.length > 0; i++) {
                // shift left by one (gas heavy); acceptable given admin-only usage and capped length.
                for (uint256 j = 0; j + 1 < arr.length; j++) {
                    arr[j] = arr[j + 1];
                }
                arr.pop();
            }
        }
    }

    // ---------- Utils ----------
    function _key(string memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(s));
    }
}
