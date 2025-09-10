// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainWisdomSanctifier {
    struct Wisdom {
        string origin;
        string insight;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Wisdom) public sanctifiedWisdom;

    event WisdomSanctified(string origin, string insight, string emotionalAPR, uint256 timestamp);

    function sanctifyWisdom(string memory origin, string memory insight, string memory emotionalAPR) public {
        sanctifiedWisdom[origin] = Wisdom(origin, insight, emotionalAPR, block.timestamp);
        emit WisdomSanctified(origin, insight, emotionalAPR, block.timestamp);
    }

    function getWisdom(string memory origin) public view returns (Wisdom memory) {
        return sanctifiedWisdom[origin];
    }
}
