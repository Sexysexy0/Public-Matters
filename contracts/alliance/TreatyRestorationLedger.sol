// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreatyRestorationLedger {
    struct Restoration {
        string treatyID;
        string region;
        string restorationType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Restoration) public restorations;

    event RestorationLogged(string treatyID, string region, string restorationType, string emotionalAPR, uint256 timestamp);

    function logRestoration(string memory treatyID, string memory region, string memory restorationType, string memory emotionalAPR) public {
        restorations[treatyID] = Restoration(treatyID, region, restorationType, emotionalAPR, block.timestamp);
        emit RestorationLogged(treatyID, region, restorationType, emotionalAPR, block.timestamp);
    }

    function getRestoration(string memory treatyID) public view returns (Restoration memory) {
        return restorations[treatyID];
    }
}
