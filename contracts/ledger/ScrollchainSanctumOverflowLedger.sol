// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainSanctumOverflowLedger {
    struct Overflow {
        string corridor;
        string overflowType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Overflow) public overflows;

    event OverflowLogged(string corridor, string overflowType, string emotionalAPR, uint256 timestamp);

    function logOverflow(string memory corridor, string memory overflowType, string memory emotionalAPR) public {
        overflows[corridor] = Overflow(corridor, overflowType, emotionalAPR, block.timestamp);
        emit OverflowLogged(corridor, overflowType, emotionalAPR, block.timestamp);
    }

    function getOverflow(string memory corridor) public view returns (Overflow memory) {
        return overflows[corridor];
    }
}
