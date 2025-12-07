// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Quartet: Durability, Transparency, Equity, Resistance
 * Arc: Right to Repair Protocol IV — Treaty ledger
 */
contract RightToRepairTreatyIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Asset {
        string vinOrId;
        string model;
        bool ownerRepairRights;
        bool openDiagnostics;
        bool durabilityCertified;
    }

    mapping(bytes32 => Asset) public assets;

    event AssetRegistered(bytes32 indexed assetKey, string vinOrId, string model);
    event RightsUpdated(bytes32 indexed assetKey, bool ownerRepairRights, bool openDiagnostics);
    event DurabilityCertified(bytes32 indexed assetKey, bool certified);
    event ResistanceFlag(bytes32 indexed assetKey, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory vinOrId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(vinOrId));
    }

    // Seal 1: Register asset into treaty ledger
    function registerAsset(string calldata vinOrId, string calldata model) external onlySteward {
        bytes32 k = keyFor(vinOrId);
        assets[k] = Asset(vinOrId, model, false, false, false);
        emit AssetRegistered(k, vinOrId, model);
    }

    // Seal 2–3: Transparency + Equity (owner repair, open diagnostics)
    function setRights(string calldata vinOrId, bool ownerRepairRights, bool openDiagnostics) external onlySteward {
        bytes32 k = keyFor(vinOrId);
        Asset storage a = assets[k];
        a.ownerRepairRights = ownerRepairRights;
        a.openDiagnostics = openDiagnostics;
        emit RightsUpdated(k, ownerRepairRights, openDiagnostics);
    }

    // Seal 1: Durability certification
    function certifyDurability(string calldata vinOrId, bool certified) external onlySteward {
        bytes32 k = keyFor(vinOrId);
        assets[k].durabilityCertified = certified;
        emit DurabilityCertified(k, certified);
    }

    // Seal 4: Resistance — flag exploitative constraints
    function flagExploit(string calldata vinOrId, string calldata reason) external onlySteward {
        emit ResistanceFlag(keyFor(vinOrId), reason);
    }
}
