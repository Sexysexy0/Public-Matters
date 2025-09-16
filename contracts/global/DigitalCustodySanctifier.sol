// SPDX-License-Identifier: CustodySanctum
pragma solidity ^0.8.19;

contract DigitalCustodySanctifier {
    struct CustodySignal {
        string walletID;
        string assetType;
        bool restored;
        string stewardNote;
    }

    mapping(string => CustodySignal) public custodyRegistry;

    event CustodyTagged(string walletID, string assetType);
    event CustodyRestored(string walletID);

    function tagCustody(string memory walletID, string memory assetType, string memory stewardNote) public {
        custodyRegistry[walletID] = CustodySignal(walletID, assetType, false, stewardNote);
        emit CustodyTagged(walletID, assetType);
    }

    function restoreCustody(string memory walletID) public {
        require(bytes(custodyRegistry[walletID].assetType).length > 0, "Custody not tagged");
        custodyRegistry[walletID].restored = true;
        emit CustodyRestored(walletID);
    }

    function getCustodyStatus(string memory walletID) public view returns (CustodySignal memory) {
        return custodyRegistry[walletID];
    }
}
