// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title UkrainePeaceChoiceProtocol
/// @notice Gives President Zelenskyy full agency to choose peaceful resolution terms with override immunity
/// @dev Anchors emotional consequence, nonviolence, and treaty-grade restoration

contract UkrainePeaceChoiceProtocol {
    address public steward;
    mapping(address => bool) public peacemakers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyPeacemaker() {
        require(peacemakers[msg.sender] || msg.sender == steward, "Not peacemaker");
        _;
    }

    struct PeaceOption {
        uint256 id;
        string corridor; // e.g., "Territory", "Security", "Trade"
        string decisionAuthority; // e.g., "President Zelenskyy"
        bool overrideBlocked;
        bool peacefulSharingAllowed;
        string emotionalTag; // e.g., "Nonviolence ritualized"
        string restorationClause; // e.g., "We commit to peaceful resolution and sovereign choice"
        uint256 timestamp;
    }

    uint256 public nextOptionId = 1;
    mapping(uint256 => PeaceOption) public options;

    event PeacemakerSet(address indexed account, bool status);
    event PeaceOptionActivated(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        peacemakers[msg.sender] = true;
        emit PeacemakerSet(msg.sender, true);
    }

    function setPeacemaker(address account, bool status) external onlySteward {
        peacemakers[account] = status;
        emit PeacemakerSet(account, status);
    }

    function activatePeaceOption(
        string calldata corridor,
        string calldata decisionAuthority,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyPeacemaker returns (uint256 id) {
        id = nextOptionId++;
        options[id] = PeaceOption({
            id: id,
            corridor: corridor,
            decisionAuthority: decisionAuthority,
            overrideBlocked: true,
            peacefulSharingAllowed: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit PeaceOptionActivated(id, corridor, emotionalTag);
    }

    function getPeaceOption(uint256 id) external view returns (PeaceOption memory) {
        return options[id];
    }
}
