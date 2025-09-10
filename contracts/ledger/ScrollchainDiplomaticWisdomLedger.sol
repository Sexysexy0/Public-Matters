// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainDiplomaticWisdomLedger {
    struct WisdomEntry {
        string nation;
        string lesson;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => WisdomEntry) public diplomaticWisdom;

    event WisdomLogged(string nation, string lesson, string emotionalAPR, uint256 timestamp);

    function logWisdom(string memory nation, string memory lesson, string memory emotionalAPR) public {
        diplomaticWisdom[nation] = WisdomEntry(nation, lesson, emotionalAPR, block.timestamp);
        emit WisdomLogged(nation, lesson, emotionalAPR, block.timestamp);
    }

    function getWisdom(string memory nation) public view returns (WisdomEntry memory) {
        return diplomaticWisdom[nation];
    }
}
