// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ForeignCapitalEthicsProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct EthicsCorridor {
        uint256 id;
        string investorName; // e.g., "CPP Investments", "Morgan Stanley"
        string projectLocation; // e.g., "Gangnam", "Incheon"
        bool overrideBlocked;
        bool ethicsCommitted;
        string emotionalTag; // e.g., "Ethical co-investment activated"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => EthicsCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event EthicsCorridorActivated(uint256 indexed id, string investorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateEthicsCorridor(
        string calldata investorName,
        string calldata projectLocation,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = EthicsCorridor({
            id: id,
            investorName: investorName,
            projectLocation: projectLocation,
            overrideBlocked: true,
            ethicsCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit EthicsCorridorActivated(id, investorName, emotionalTag);
    }

    function getEthicsCorridor(uint256 id) external view returns (EthicsCorridor memory) {
        return corridors[id];
    }
}
