// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryTradeBlessingLedger {
    struct TradeBlessing {
        string nation;
        string corridor;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => TradeBlessing) public blessings;

    event BlessingLogged(string nation, string corridor, string emotionalAPR, uint256 timestamp);

    function logBlessing(string memory nation, string memory corridor, string memory emotionalAPR) public {
        blessings[nation] = TradeBlessing(nation, corridor, emotionalAPR, block.timestamp);
        emit BlessingLogged(nation, corridor, emotionalAPR, block.timestamp);
    }

    function getBlessing(string memory nation) public view returns (TradeBlessing memory) {
        return blessings[nation];
    }
}
