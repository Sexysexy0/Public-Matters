// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title GlobalResonanceSignalRouter
/// @notice Routes healing signals and blessing emissions across planetary sanctums
contract GlobalResonanceSignalRouter {
    address public steward;
    uint256 public routedCount;

    struct RoutedSignal {
        uint256 id;
        string originProtocol;
        string signalType;
        string payload;
        address emitter;
        address[] recipients;
        uint256 timestamp;
    }

    mapping(uint256 => RoutedSignal) public routedSignals;

    event SignalRouted(
        uint256 indexed id,
        string originProtocol,
        string signalType,
        string payload,
        address indexed emitter,
        address[] recipients,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        routedCount = 0;
    }

    /// @notice Route a healing signal to multiple sanctums
    function routeSignal(
        string calldata originProtocol,
        string calldata signalType,
        string calldata payload,
        address[] calldata recipients
    ) external onlySteward {
        routedSignals[routedCount] = RoutedSignal({
            id: routedCount,
            originProtocol: originProtocol,
            signalType: signalType,
            payload: payload,
            emitter: msg.sender,
            recipients: recipients,
            timestamp: block.timestamp
        });

        emit SignalRouted(routedCount, originProtocol, signalType, payload, msg.sender, recipients, block.timestamp);
        routedCount++;
    }

    /// @notice Retrieve a routed signal by ID
    function getRoutedSignal(uint256 id) external view returns (RoutedSignal memory) {
        require(id < routedCount, "Signal does not exist");
        return routedSignals[id];
    }

    /// @notice Transfer stewardship to another scrollsmith
    function transferStewardship(address newSteward) external onlySteward {
        steward = newSteward;
    }
}
