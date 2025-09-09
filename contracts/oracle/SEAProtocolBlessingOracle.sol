// SPDX-License-Identifier: SEAProtocolBlessing-License
pragma solidity ^0.8.0;

contract SEAProtocolBlessingOracle {
    address public steward;

    struct BlessingEvent {
        string asset;
        string protocol;
        string ritualType;
        bool liquidityActivated;
        uint256 timestamp;
    }

    BlessingEvent[] public blessings;

    event BlessingEmitted(string asset, string protocol, string ritual, bool liquidity, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory asset, string memory protocol, string memory ritualType, bool liquidityActivated) public {
        require(msg.sender == steward, "Only steward can emit");
        blessings.push(BlessingEvent(asset, protocol, ritualType, liquidityActivated, block.timestamp));
        emit BlessingEmitted(asset, protocol, ritualType, liquidityActivated, block.timestamp);
    }

    function getBlessing(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        BlessingEvent memory b = blessings[index];
        return (b.asset, b.protocol, b.ritualType, b.liquidityActivated, b.timestamp);
    }
}
