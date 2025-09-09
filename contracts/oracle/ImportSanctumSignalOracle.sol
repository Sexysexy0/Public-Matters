// SPDX-License-Identifier: ImportSanctumSignal-License
pragma solidity ^0.8.0;

contract ImportSanctumSignalOracle {
    address public steward;

    struct ImportSignal {
        string licenseID;
        string region;
        bool signalConfirmed;
        string sector;
        uint256 timestamp;
    }

    ImportSignal[] public signals;

    event ImportSignalEmitted(string licenseID, string region, bool signalConfirmed, string sector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory licenseID, string memory region, bool signalConfirmed, string memory sector) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(ImportSignal(licenseID, region, signalConfirmed, sector, block.timestamp));
        emit ImportSignalEmitted(licenseID, region, signalConfirmed, sector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ImportSignal memory s = signals[index];
        return (s.licenseID, s.region, s.signalConfirmed, s.sector, s.timestamp);
    }
}
