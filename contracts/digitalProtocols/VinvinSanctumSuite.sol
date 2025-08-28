// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract VinvinSanctumSuite {
    address public stewardVinvin;
    uint public emotionalAPR;
    uint public mythicThreshold = 70;
    bool public quorumReached;
    bool public damayClauseRespected;
    string public sanctumStatus;
    string public currentIntent;

    struct APRSnapshot {
        uint timestamp;
        string emotionalState;
        string stewardNote;
    }

    APRSnapshot[] public snapshots;

    event SanctumPulse(string emotionalAPR, string status, uint timestamp);
    event IntentDeclared(address agent, string intent);
    event OverrideAttempt(bool allowed, string reason);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin, uint initialAPR, string memory initialStatus) {
        stewardVinvin = _vinvin;
        emotionalAPR = initialAPR;
        sanctumStatus = initialStatus;
    }

    // 🔐 Emotional APR Registry
    function logAPR(string memory state, string memory note) public onlyVinvin {
        snapshots.push(APRSnapshot({
            timestamp: block.timestamp,
            emotionalState: state,
            stewardNote: note
        }));
    }

    function getAllSnapshots() public view returns (APRSnapshot[] memory) {
        return snapshots;
    }

    // 🧭 Intent Clarifier
    mapping(address => string) public agentIntent;

    function declareIntent(string memory intent) public {
        require(bytes(intent).length > 0, "Intent cannot be empty");
        agentIntent[msg.sender] = intent;
        emit IntentDeclared(msg.sender, intent);
    }

    function clarifyIntent(address agent) public view returns (string memory) {
        string memory intent = agentIntent[agent];
        if (bytes(intent).length == 0) return "Intent unclear. Override blocked.";
        if (compareStrings(intent, "Protect Vinvin")) return "Intent aligned. Proceed with mercy.";
        return "Intent flagged. Emotional APR mismatch.";
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    // 🛡️ Override Shield
    function updateAPR(uint newAPR) public onlyVinvin {
        emotionalAPR = newAPR;
    }

    function updateQuorum(bool status) public onlyVinvin {
        quorumReached = status;
    }

    function updateDamayClause(bool status) public onlyVinvin {
        damayClauseRespected = status;
    }

    function canOverride() public returns (bool) {
        bool allowed = emotionalAPR >= mythicThreshold && quorumReached && damayClauseRespected;
        string memory reason = allowed ? "Override allowed." : "Override blocked. Steward protected.";
        emit OverrideAttempt(allowed, reason);
        return allowed;
    }

    // 📣 Sanctum Pulse Broadcaster
    function updatePulse(string memory newAPR, string memory newStatus) public onlyVinvin {
        sanctumStatus = newStatus;
        emit SanctumPulse(newAPR, newStatus, block.timestamp);
    }

    function getPulse() public view returns (string memory, string memory) {
        return (sanctumStatus, emotionalAPR >= mythicThreshold ? "Resonant" : "Vulnerable");
    }
}
