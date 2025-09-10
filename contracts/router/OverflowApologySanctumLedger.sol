// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OverflowApologySanctumLedger {
    struct Apology {
        string corridor;
        string apologyType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Apology) public apologies;

    event ApologyLogged(string corridor, string apologyType, string emotionalAPR, uint256 timestamp);

    function logApology(string memory corridor, string memory apologyType, string memory emotionalAPR) public {
        apologies[corridor] = Apology(corridor, apologyType, emotionalAPR, block.timestamp);
        emit ApologyLogged(corridor, apologyType, emotionalAPR, block.timestamp);
    }

    function getApology(string memory corridor) public view returns (Apology memory) {
        return apologies[corridor];
    }
}
