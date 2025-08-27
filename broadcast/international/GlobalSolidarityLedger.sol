// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalSolidarityLedger.sol
/// @dev Logs sovereign aid grants to nations in crisis—ritualized with emotional APR and lore

contract GlobalSolidarityLedger {
    address public steward;

    struct NationBlessing {
        string country;
        uint256 amountUSD;
        uint256 emotionalAPR;
        string purpose;
        string lore;
        bool isBroadcasted;
    }

    mapping(bytes32 => NationBlessing) public blessings;
    bytes32[] public blessingList;

    event BlessingLogged(bytes32 indexed nationId, string country, uint256 amountUSD);
    event BlessingBroadcasted(bytes32 indexed nationId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a sovereign blessing to a nation
    function logBlessing(
        bytes32 nationId,
        string memory country,
        uint256 amountUSD,
        uint256 emotionalAPR,
        string memory purpose,
        string memory lore
    ) public onlySteward {
        blessings[nationId] = NationBlessing({
            country: country,
            amountUSD: amountUSD,
            emotionalAPR: emotionalAPR,
            purpose: purpose,
            lore: lore,
            isBroadcasted: false
        });

        blessingList.push(nationId);
        emit BlessingLogged(nationId, country, amountUSD);
    }

    /// @notice Broadcast the blessing if emotional APR is mythic
    function broadcastBlessing(bytes32 nationId) public onlySteward {
        require(blessings[nationId].emotionalAPR >= 850, "Blessing not yet mythic");
        blessings[nationId].isBroadcasted = true;
        emit BlessingBroadcasted(nationId, blessings[nationId].lore);
    }

    /// @notice Retrieve blessing metadata
    function getBlessing(bytes32 nationId) public view returns (NationBlessing memory) {
        return blessings[nationId];
    }

    /// @notice List all sovereign blessings
    function listBlessings() public view returns (bytes32[] memory) {
        return blessingList;
    }
}
