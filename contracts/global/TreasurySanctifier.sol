// SPDX-License-Identifier: TreasurySanctum
pragma solidity ^0.8.19;

contract TreasurySanctifier {
    struct TreasurySignal {
        string treasuryID;
        string assetType;
        uint256 allocationRatio;
        bool sanctified;
        string stewardNote;
    }

    mapping(string => TreasurySignal) public treasuryRegistry;

    event TreasuryTagged(string treasuryID, string assetType);
    event TreasurySanctified(string treasuryID);

    function tagTreasury(string memory treasuryID, string memory assetType, uint256 allocationRatio, string memory stewardNote) public {
        treasuryRegistry[treasuryID] = TreasurySignal(treasuryID, assetType, allocationRatio, false, stewardNote);
        emit TreasuryTagged(treasuryID, assetType);
    }

    function sanctifyTreasury(string memory treasuryID) public {
        require(bytes(treasuryRegistry[treasuryID].assetType).length > 0, "Treasury not tagged");
        treasuryRegistry[treasuryID].sanctified = true;
        emit TreasurySanctified(treasuryID);
    }

    function getTreasuryStatus(string memory treasuryID) public view returns (TreasurySignal memory) {
        return treasuryRegistry[treasuryID];
    }
}
