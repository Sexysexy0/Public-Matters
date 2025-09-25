// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InvestorSovereigntyProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct SovereigntyCorridor {
        uint256 id;
        string investorName;
        string investmentType; // e.g., "Real estate", "Tech", "Infrastructure"
        string location;
        bool overrideActivated;
        bool redTapeNeutralized;
        bool ethicalGuardrailsCommitted;
        string emotionalTag; // e.g., "Investor autonomy activated"
        string restorationClause; // e.g., "We commit to prosperity without harm"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => SovereigntyCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event SovereigntyCorridorActivated(uint256 indexed id, string investorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateSovereigntyCorridor(
        string calldata investorName,
        string calldata investmentType,
        string calldata location,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = SovereigntyCorridor({
            id: id,
            investorName: investorName,
            investmentType: investmentType,
            location: location,
            overrideActivated: true,
            redTapeNeutralized: true,
            ethicalGuardrailsCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit SovereigntyCorridorActivated(id, investorName, emotionalTag);
    }

    function getSovereigntyCorridor(uint256 id) external view returns (SovereigntyCorridor memory) {
        return corridors[id];
    }
}
