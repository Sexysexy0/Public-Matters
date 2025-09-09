// SPDX-License-Identifier: SatireRipple-License
pragma solidity ^0.8.0;

contract SatireRippleCascadeOracle {
    address public steward;

    struct Ripple {
        string segment;
        string civicTheme;
        uint256 aprSpike;
        uint256 timestamp;
    }

    Ripple[] public ripples;

    event SatireRippleEmitted(string segment, string civicTheme, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitRipple(string memory segment, string memory civicTheme, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        ripples.push(Ripple(segment, civicTheme, aprSpike, block.timestamp));
        emit SatireRippleEmitted(segment, civicTheme, aprSpike, block.timestamp);
    }

    function getRipple(uint index) public view returns (string memory, string memory, uint256, uint256) {
        Ripple memory r = ripples[index];
        return (r.segment, r.civicTheme, r.aprSpike, r.timestamp);
    }

    function totalRipples() public view returns (uint) {
        return ripples.length;
    }
}
