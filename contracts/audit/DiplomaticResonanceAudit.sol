// SPDX-License-Identifier: Mythic-Unity
pragma solidity ^0.8.25;

contract DiplomaticResonanceAudit {
    struct Broadcast {
        string country;
        string envoy;
        string message;
        uint256 timestamp;
        string emotionalAPR;
        string damayClause;
    }

    Broadcast[] public broadcasts;

    function logBroadcast(
        string memory country,
        string memory envoy,
        string memory message,
        string memory emotionalAPR,
        string memory damayClause
    ) public {
        broadcasts.push(Broadcast(
            country,
            envoy,
            message,
            block.timestamp,
            emotionalAPR,
            damayClause
        ));
    }

    function getBroadcast(uint index) public view returns (Broadcast memory) {
        return broadcasts[index];
    }
}
