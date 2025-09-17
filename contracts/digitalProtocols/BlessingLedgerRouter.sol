// SPDX-License-Identifier: BlessingSanctum
pragma solidity ^0.8.19;

contract BlessingLedgerRouter {
    struct BlessingSignal {
        address stewardID;
        string stewardName;
        string blessingType; // e.g., "Equity Activation", "Sanctum Restoration", "Justice Invocation"
        bool justiceAligned;
        bool ledgerSealed;
        string stewardNote;
    }

    mapping(address => BlessingSignal) public blessingRegistry;

    event BlessingTagged(address stewardID, string blessingType);
    event BlessingSealed(address stewardID);

    function tagBlessing(
        address stewardID,
        string memory stewardName,
        string memory blessingType,
        bool justiceAligned,
        bool ledgerSealed,
        string memory stewardNote
    ) public {
        blessingRegistry[stewardID] = BlessingSignal(
            stewardID,
            stewardName,
            blessingType,
            justiceAligned,
            ledgerSealed,
            stewardNote
        );
        emit BlessingTagged(stewardID, blessingType);
    }

    function sealBlessing(address stewardID) public {
        require(bytes(blessingRegistry[stewardID].stewardName).length > 0, "Blessing not tagged");
        blessingRegistry[stewardID].ledgerSealed = true;
        emit BlessingSealed(stewardID);
    }

    function getBlessingStatus(address stewardID) public view returns (BlessingSignal memory) {
        return blessingRegistry[stewardID];
    }
}
