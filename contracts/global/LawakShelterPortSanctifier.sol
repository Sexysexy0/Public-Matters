// SPDX-License-Identifier: LawakSanctum
pragma solidity ^0.8.19;

contract LawakShelterPortSanctifier {
    struct PortSignal {
        string projectID;
        uint256 budget;
        string contractor;
        bool completed;
        string stewardNote;
    }

    mapping(string => PortSignal) public portRegistry;

    event PortTagged(string projectID, string contractor);
    event PortSanctified(string projectID);

    function tagPort(string memory projectID, uint256 budget, string memory contractor, string memory stewardNote) public {
        portRegistry[projectID] = PortSignal(projectID, budget, contractor, false, stewardNote);
        emit PortTagged(projectID, contractor);
    }

    function sanctifyPort(string memory projectID) public {
        require(portRegistry[projectID].budget > 0, "Budget not tagged");
        portRegistry[projectID].completed = true;
        emit PortSanctified(projectID);
    }

    function getPortStatus(string memory projectID) public view returns (PortSignal memory) {
        return portRegistry[projectID];
    }
}
