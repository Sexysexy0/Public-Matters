// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FirewallStressTestProtocol
/// @notice Simulates packet load and tags infrastructure resilience
/// @dev Anchors stress audit and emotional consequence tagging

contract FirewallStressTestProtocol {
    address public steward;
    mapping(address => bool) public testers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyTester() {
        require(testers[msg.sender] || msg.sender == steward, "Not tester");
        _;
    }

    struct StressTest {
        uint256 id;
        string systemName;
        uint256 simulatedPacketRateBpps;
        string resilienceTier; // e.g., "High", "Moderate", "Critical"
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextTestId = 1;
    mapping(uint256 => StressTest) public tests;

    event TesterSet(address indexed account, bool status);
    event StressTestLogged(uint256 indexed id, string systemName, string resilienceTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        testers[msg.sender] = true;
        emit TesterSet(msg.sender, true);
    }

    function setTester(address account, bool status) external onlySteward {
        testers[account] = status;
        emit TesterSet(account, status);
    }

    function logStressTest(
        string calldata systemName,
        uint256 simulatedPacketRateBpps,
        string calldata resilienceTier,
        string calldata emotionalTag
    ) external onlyTester returns (uint256 id) {
        id = nextTestId++;
        tests[id] = StressTest({
            id: id,
            systemName: systemName,
            simulatedPacketRateBpps: simulatedPacketRateBpps,
            resilienceTier: resilienceTier,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit StressTestLogged(id, systemName, resilienceTier, emotionalTag);
    }

    function getTest(uint256 id) external view returns (StressTest memory) {
        return tests[id];
    }
}
