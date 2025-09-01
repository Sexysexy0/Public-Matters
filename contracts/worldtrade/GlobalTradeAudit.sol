// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GlobalTradeAudit {
    struct TradeCorridor {
        string exporter;
        string importer;
        string assetType;
        uint256 volume;
        string timestamp;
        bool blessed;
        bool damayClauseEnforced;
        string permitTag;
    }

    mapping(string => TradeCorridor) public corridors;
    string[] public corridorIDs;

    event CorridorLogged(string corridorID);
    event PermitIssued(string corridorID, string permitTag);
    event DamayClauseVerified(string corridorID);

    function logCorridor(
        string memory _corridorID,
        string memory _exporter,
        string memory _importer,
        string memory _assetType,
        uint256 _volume,
        string memory _timestamp,
        bool _blessed,
        bool _damayClauseEnforced,
        string memory _permitTag
    ) public {
        TradeCorridor memory newCorridor = TradeCorridor({
            exporter: _exporter,
            importer: _importer,
            assetType: _assetType,
            volume: _volume,
            timestamp: _timestamp,
            blessed: _blessed,
            damayClauseEnforced: _damayClauseEnforced,
            permitTag: _permitTag
        });

        corridors[_corridorID] = newCorridor;
        corridorIDs.push(_corridorID);
        emit CorridorLogged(_corridorID);
    }

    function issuePermit(string memory _corridorID, string memory _permitTag) public {
        TradeCorridor storage corridor = corridors[_corridorID];
        corridor.permitTag = _permitTag;
        emit PermitIssued(_corridorID, _permitTag);
    }

    function verifyDamayClause(string memory _corridorID) public {
        TradeCorridor storage corridor = corridors[_corridorID];
        corridor.damayClauseEnforced = true;
        emit DamayClauseVerified(_corridorID);
    }

    function getCorridorCount() public view returns (uint256) {
        return corridorIDs.length;
    }
}
