// SPDX-License-Identifier: RATSanctum
pragma solidity ^0.8.19;

contract AsyncRATContainmentRouter {
    struct RATSignal {
        string pluginID;
        string originTool;
        bool contained;
        string stewardNote;
    }

    mapping(string => RATSignal) public ratRegistry;

    event RATTagged(string pluginID, string originTool);
    event ContainmentActivated(string pluginID);

    function tagRAT(string memory pluginID, string memory originTool, string memory stewardNote) public {
        ratRegistry[pluginID] = RATSignal(pluginID, originTool, false, stewardNote);
        emit RATTagged(pluginID, originTool);
    }

    function activateContainment(string memory pluginID) public {
        require(bytes(ratRegistry[pluginID].originTool).length > 0, "Tool not tagged");
        ratRegistry[pluginID].contained = true;
        emit ContainmentActivated(pluginID);
    }

    function getContainmentStatus(string memory pluginID) public view returns (RATSignal memory) {
        return ratRegistry[pluginID];
    }
}
