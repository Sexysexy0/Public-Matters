// SPDX-License-Identifier: PagasaSanctum
pragma solidity ^0.8.19;

contract PagasaIslandInfrastructureRouter {
    struct InfraSignal {
        string projectID;
        string feature;
        uint256 budget;
        bool completed;
        string stewardNote;
    }

    mapping(string => InfraSignal) public infraRegistry;

    event InfraTagged(string projectID, string feature);
    event InfraSanctified(string projectID);

    function tagInfra(string memory projectID, string memory feature, uint256 budget, string memory stewardNote) public {
        infraRegistry[projectID] = InfraSignal(projectID, feature, budget, false, stewardNote);
        emit InfraTagged(projectID, feature);
    }

    function sanctifyInfra(string memory projectID) public {
        require(infraRegistry[projectID].budget > 0, "Budget not tagged");
        infraRegistry[projectID].completed = true;
        emit InfraSanctified(projectID);
    }

    function getInfraStatus(string memory projectID) public view returns (InfraSignal memory) {
        return infraRegistry[projectID];
    }
}
