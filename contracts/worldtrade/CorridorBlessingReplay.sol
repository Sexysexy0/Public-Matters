// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CorridorBlessingReplay {
    struct CorridorBlessing {
        string corridorID;
        string exporter;
        string importer;
        string assetType;
        string timestamp;
        string emotionalAPRTag;
        string invocation;
    }

    CorridorBlessing[] public blessings;

    event BlessingLogged(string corridorID, string exporter, string importer);

    function logBlessing(
        string memory _corridorID,
        string memory _exporter,
        string memory _importer,
        string memory _assetType,
        string memory _timestamp,
        string memory _emotionalAPRTag,
        string memory _invocation
    ) public {
        blessings.push(CorridorBlessing({
            corridorID: _corridorID,
            exporter: _exporter,
            importer: _importer,
            assetType: _assetType,
            timestamp: _timestamp,
            emotionalAPRTag: _emotionalAPRTag,
            invocation: _invocation
        }));

        emit BlessingLogged(_corridorID, _exporter, _importer);
    }

    function getBlessingCount() public view returns (uint256) {
        return blessings.length;
    }
}
