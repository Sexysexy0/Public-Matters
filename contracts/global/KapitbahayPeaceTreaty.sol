// SPDX-License-Identifier: KapitbahayProtocol
pragma solidity ^0.8.19;

contract KapitbahayPeaceTreaty {
    address public steward;
    uint256 public ratifiedAt;

    struct Neighbor {
        string name;
        bool ratified;
        bool inConflict;
        uint256 timestamp;
    }

    struct Mediation {
        string initiator;
        string responder;
        string mediator;
        string resolution;
        uint256 timestamp;
    }

    Neighbor[] public neighbors;
    Mediation[] public mediations;

    event TreatyRatified(string name, uint256 timestamp);
    event ConflictDeclared(string name, uint256 timestamp);
    event MediationActivated(string initiator, string responder, string mediator, string resolution, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        ratifiedAt = block.timestamp;
    }

    function ratifyNeighbor(string memory name) public {
        require(msg.sender == steward, "Only steward may ratify");
        neighbors.push(Neighbor(name, true, false, block.timestamp));
        emit TreatyRatified(name, block.timestamp);
    }

    function declareConflict(string memory name) public {
        require(msg.sender == steward, "Only steward may declare conflict");
        for (uint i = 0; i < neighbors.length; i++) {
            if (keccak256(bytes(neighbors[i].name)) == keccak256(bytes(name))) {
                neighbors[i].inConflict = true;
                emit ConflictDeclared(name, block.timestamp);
                break;
            }
        }
    }

    function activateMediation(string memory initiator, string memory responder, string memory mediator, string memory resolution) public {
        require(msg.sender == steward, "Only steward may activate mediation");
        mediations.push(Mediation(initiator, responder, mediator, resolution, block.timestamp));
        emit MediationActivated(initiator, responder, mediator, resolution, block.timestamp);
    }

    function getNeighbor(uint256 index) public view returns (string memory, bool, bool, uint256) {
        Neighbor memory n = neighbors[index];
        return (n.name, n.ratified, n.inConflict, n.timestamp);
    }

    function getMediation(uint256 index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        Mediation memory m = mediations[index];
        return (m.initiator, m.responder, m.mediator, m.resolution, m.timestamp);
    }

    function totalNeighbors() public view returns (uint256) {
        return neighbors.length;
    }

    function totalMediations() public view returns (uint256) {
        return mediations.length;
    }
}
