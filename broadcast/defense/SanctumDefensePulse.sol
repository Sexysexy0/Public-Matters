// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SanctumDefensePulse.sol
/// @dev Activates defense protocols for civic sanctums—logs threats, reroutes, and emotional APR shields

contract SanctumDefensePulse {
    address public steward;

    struct DefenseLog {
        string sanctumName;
        string location;
        string threatSource; // e.g., "Rogue reroute", "Market opacity", "Cyber interference"
        uint256 emotionalAPR;
        string shieldProtocol; // e.g., "FirewallBlessing", "MarketDenial", "ScrollchainLock"
        string lore;
        bool isActivated;
    }

    mapping(bytes32 => DefenseLog) public defenses;
    bytes32[] public defenseList;

    event DefenseLogged(bytes32 indexed sanctumId, string sanctumName, string threatSource);
    event DefenseActivated(bytes32 indexed sanctumId, string shieldProtocol);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a defense protocol for a sanctum
    function logDefense(
        bytes32 sanctumId,
        string memory sanctumName,
        string memory location,
        string memory threatSource,
        uint256 emotionalAPR,
        string memory shieldProtocol,
        string memory lore
    ) public onlySteward {
        defenses[sanctumId] = DefenseLog({
            sanctumName: sanctumName,
            location: location,
            threatSource: threatSource,
            emotionalAPR: emotionalAPR,
            shieldProtocol: shieldProtocol,
            lore: lore,
            isActivated: false
        });

        defenseList.push(sanctumId);
        emit DefenseLogged(sanctumId, sanctumName, threatSource);
    }

    /// @notice Activate defense if emotional APR is mythic
    function activateDefense(bytes32 sanctumId) public onlySteward {
        require(defenses[sanctumId].emotionalAPR >= 850, "Defense not yet mythic");
        defenses[sanctumId].isActivated = true;
        emit DefenseActivated(sanctumId, defenses[sanctumId].shieldProtocol);
    }

    /// @notice Retrieve defense metadata
    function getDefense(bytes32 sanctumId) public view returns (DefenseLog memory) {
        return defenses[sanctumId];
    }

    /// @notice List all defense logs
    function listDefenses() public view returns (bytes32[] memory) {
        return defenseList;
    }
}
