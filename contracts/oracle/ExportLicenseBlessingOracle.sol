// SPDX-License-Identifier: ExportLicenseBlessing-License
pragma solidity ^0.8.0;

contract ExportLicenseBlessingOracle {
    address public steward;

    struct BlessingSignal {
        string licenseID;
        string region;
        bool blessingConfirmed;
        string sector;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ExportBlessingEmitted(string licenseID, string region, bool blessingConfirmed, string sector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory licenseID, string memory region, bool blessingConfirmed, string memory sector) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(BlessingSignal(licenseID, region, blessingConfirmed, sector, block.timestamp));
        emit ExportBlessingEmitted(licenseID, region, blessingConfirmed, sector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.licenseID, s.region, s.blessingConfirmed, s.sector, s.timestamp);
    }
}
