// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BlessingReplay {
    struct Blessing {
        string assetID;
        string stewardName;
        string ritualType; // "Sanctum", "Gold", "Succession", etc.
        string timestamp;
        string emotionalAPRTag;
        string broadcastTag;
        string invocation;
    }

    Blessing[] public blessings;

    event BlessingLogged(string assetID, string stewardName, string ritualType);

    function logBlessing(
        string memory _assetID,
        string memory _stewardName,
        string memory _ritualType,
        string memory _timestamp,
        string memory _emotionalAPRTag,
        string memory _broadcastTag,
        string memory _invocation
    ) public {
        blessings.push(Blessing({
            assetID: _assetID,
            stewardName: _stewardName,
            ritualType: _ritualType,
            timestamp: _timestamp,
            emotionalAPRTag: _emotionalAPRTag,
            broadcastTag: _broadcastTag,
            invocation: _invocation
        }));

        emit BlessingLogged(_assetID, _stewardName, _ritualType);
    }

    function getBlessingCount() public view returns (uint256) {
        return blessings.length;
    }

    function getBlessingByIndex(uint256 index) public view returns (
        string memory assetID,
        string memory stewardName,
        string memory ritualType,
        string memory timestamp,
        string memory emotionalAPRTag,
        string memory broadcastTag,
        string memory invocation
    ) {
        Blessing memory b = blessings[index];
        return (
            b.assetID,
            b.stewardName,
            b.ritualType,
            b.timestamp,
            b.emotionalAPRTag,
            b.broadcastTag,
            b.invocation
        );
    }
}
