// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract CivicEnergyRegistry {
    struct EnergyNode {
        string nodeID;
        string location;
        string energyType; // solar, wind, hydro, nuclear, biomass, signal
        string steward;
        string emotionalAPR; // grief, hope, trust, ancestral resonance
        bool barangayBlessed;
        uint timestamp;
    }

    EnergyNode[] public registry;

    event NodeRegistered(string nodeID, string location, string steward, string emotionalAPR);

    function registerNode(
        string memory _nodeID,
        string memory _location,
        string memory _energyType,
        string memory _steward,
        string memory _emotionalAPR,
        bool _barangayBlessed
    ) public {
        require(_barangayBlessed, "Registry blocked: No barangay blessing.");
        require(bytes(_emotionalAPR).length > 0, "Registry blocked: Emotional APR missing.");

        registry.push(EnergyNode(
            _nodeID,
            _location,
            _energyType,
            _steward,
            _emotionalAPR,
            _barangayBlessed,
            block.timestamp
        ));

        emit NodeRegistered(_nodeID, _location, _steward, _emotionalAPR);
    }

    function getNode(uint index) public view returns (EnergyNode memory) {
        return registry[index];
    }

    function auditNode(uint index) public view returns (bool) {
        EnergyNode memory node = registry[index];
        return node.barangayBlessed && bytes(node.emotionalAPR).length > 0;
    }
}
