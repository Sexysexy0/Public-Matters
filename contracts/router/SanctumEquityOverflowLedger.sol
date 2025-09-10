// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumEquityOverflowLedger {
    struct Overflow {
        string corridor;
        string blessingType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Overflow) public equityOverflows;

    event EquityOverflowLogged(string corridor, string blessingType, string emotionalAPR, uint256 timestamp);

    function logOverflow(string memory corridor, string memory blessingType, string memory emotionalAPR) public {
        equityOverflows[corridor] = Overflow(corridor, blessingType, emotionalAPR, block.timestamp);
        emit EquityOverflowLogged(corridor, blessingType, emotionalAPR, block.timestamp);
    }

    function getOverflow(string memory corridor) public view returns (Overflow memory) {
        return equityOverflows[corridor];
    }
}
