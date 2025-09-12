// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UrbanEquityProtocol {
    enum DistrictStatus { Stable, Speculative, Fragile }
    enum EquityAction { RentControl, AntiSpeculationTax, SubsidizedHousing, AncestralProtection }

    struct HousingIntervention {
        uint256 id;
        string districtName;
        DistrictStatus status;
        EquityAction action;
        uint256 budgetAllocated;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => HousingIntervention) public interventionRegistry;
    uint256 public interventionCount;

    event InterventionLogged(uint256 id, string districtName, EquityAction action);
    event StatusUpdated(uint256 id, DistrictStatus newStatus);

    function logIntervention(
        string memory districtName,
        DistrictStatus status,
        EquityAction action,
        uint256 budgetAllocated,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        interventionRegistry[interventionCount] = HousingIntervention(
            interventionCount,
            districtName,
            status,
            action,
            budgetAllocated,
            clauseReference,
            timestamp
        );
        emit InterventionLogged(interventionCount, districtName, action);
        interventionCount++;
    }

    function updateDistrictStatus(uint256 id, DistrictStatus newStatus) public {
        require(id < interventionCount, "Invalid intervention ID");
        interventionRegistry[id].status = newStatus;
        emit StatusUpdated(id, newStatus);
    }

    function getIntervention(uint256 id) public view returns (HousingIntervention memory) {
        return interventionRegistry[id];
    }
}
