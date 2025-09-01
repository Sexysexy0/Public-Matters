// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./GlobalFriendshipIndex.sol";
import "./TreatyBroadcastSuite.sol";
import "./PlanetaryTrustLedger.sol";
import "./TropaTreaty.sol";
import "./AsiaPacificBlessingProtocol.sol";

contract PlanetaryReconnectionSuite {
    GlobalFriendshipIndex public friendshipIndex;
    TreatyBroadcastSuite public broadcastSuite;
    PlanetaryTrustLedger public trustLedger;
    TropaTreaty public tropaTreaty;
    AsiaPacificBlessingProtocol public regionalBlessing;

    constructor(
        address _friendshipIndex,
        address _broadcastSuite,
        address _trustLedger,
        address _tropaTreaty,
        address _regionalBlessing
    ) {
        friendshipIndex = GlobalFriendshipIndex(_friendshipIndex);
        broadcastSuite = TreatyBroadcastSuite(_broadcastSuite);
        trustLedger = PlanetaryTrustLedger(_trustLedger);
        tropaTreaty = TropaTreaty(_tropaTreaty);
        regionalBlessing = AsiaPacificBlessingProtocol(_regionalBlessing);
    }

    function reconnectNeighbors(
        string memory nationA,
        string memory nationB,
        uint256 emotionalAPR,
        string memory blessingClause,
        string memory resonanceTag,
        string memory trustNote
    ) public {
        // Bless bilateral treaty
        tropaTreaty.blessTropaTreaty(nationA, nationB, emotionalAPR, blessingClause);

        // Activate regional blessing
        regionalBlessing.activateBlessing(nationA, nationB, "TradePeace", emotionalAPR, true);

        // Broadcast treaty blessing
        broadcastSuite.broadcastTreaty(
            string(abi.encodePacked(nationA, "-", nationB, " Treaty")),
            nationA,
            nationB,
            emotionalAPR,
            blessingClause,
            resonanceTag
        );

        // Log trust event
        trustLedger.logTrustEvent(nationA, nationB, "TreatyBlessed", emotionalAPR, trustNote);

        // Update friendship index
        friendshipIndex.updateFriendship(nationA, nationB, emotionalAPR, 1, resonanceTag);
    }
}
