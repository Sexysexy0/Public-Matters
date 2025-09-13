// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumGenesis {
    enum OriginType { Steward, MythBearer, TreatyFounder, Scrollsmith }
    enum GenesisTier { Local, Ancestral, Cosmic }

    struct GenesisBlessing {
        uint256 id;
        OriginType originType;
        GenesisTier genesisTier;
        string stewardTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => GenesisBlessing) public genesisRegistry;
    uint256 public genesisCount;

    event GenesisLogged(uint256 id, OriginType originType, GenesisTier genesisTier);
    event TierUpdated(uint256 id, GenesisTier newGenesisTier);

    function logGenesis(
        OriginType originType,
        GenesisTier genesisTier,
        string memory stewardTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        genesisRegistry[genesisCount] = GenesisBlessing(
            genesisCount,
            originType,
            genesisTier,
            stewardTag,
            clauseReference,
            timestamp
        );
        emit GenesisLogged(genesisCount, originType, genesisTier);
        genesisCount++;
    }

    function updateTier(uint256 id, GenesisTier newGenesisTier) public {
        require(id < genesisCount, "Invalid genesis ID");
        genesisRegistry[id].genesisTier = newGenesisTier;
        emit TierUpdated(id, newGenesisTier);
    }

    function getGenesisBlessing(uint256 id) public view returns (GenesisBlessing memory) {
        return genesisRegistry[id];
    }
}
