// SPDX-License-Identifier: FarmSanctumBlessing-License
pragma solidity ^0.8.0;

contract FarmSanctumBlessingOracle {
    address public steward;

    struct BlessingSignal {
        string farmID;
        string region;
        bool blessingConfirmed;
        string stressType;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event BlessingEmitted(string farmID, string region, bool blessingConfirmed, string stressType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory farmID, string memory region, bool blessingConfirmed, string memory stressType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(BlessingSignal(farmID, region, blessingConfirmed, stressType, block.timestamp));
        emit BlessingEmitted(farmID, region, blessingConfirmed, stressType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.farmID, s.region, s.blessingConfirmed, s.stressType, s.timestamp);
    }
}
