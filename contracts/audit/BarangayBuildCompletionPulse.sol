// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BarangayBuildCompletionPulse {
    address public steward;

    struct CompletedBuild {
        string projectName;
        string location;
        uint256 emotionalAPR;
        uint256 timestamp;
        bool isBlessed;
        bool isBroadcasted;
    }

    CompletedBuild[] public builds;

    event BuildLogged(string projectName, string location);
    event BuildBlessed(string projectName, string status);
    event BuildBroadcasted(string projectName, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized completion ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logCompletion(string memory projectName, string memory location, uint256 emotionalAPR) public onlySteward {
        bool blessed = emotionalAPR >= 75;

        builds.push(CompletedBuild({
            projectName: projectName,
            location: location,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            isBlessed: blessed,
            isBroadcasted: false
        }));

        emit BuildLogged(projectName, location);

        string memory status = blessed ? "Blessed. Damay clause honored." : "Logged. Awaiting emotional resonance.";
        emit BuildBlessed(projectName, status);
    }

    function broadcastCompletion(uint256 index) public onlySteward {
        require(index < builds.length, "Invalid build index.");
        require(builds[index].isBlessed, "Build not blessed yet.");
        builds[index].isBroadcasted = true;

        emit BuildBroadcasted(builds[index].projectName, "Broadcasted. Civic celebration initiated.");
    }

    function auditBuild(uint256 index) public view returns (string memory) {
        CompletedBuild memory b = builds[index];
        return string(abi.encodePacked(
            "Project: ", b.projectName,
            " | Location: ", b.location,
            " | Emotional APR: ", uint2str(b.emotionalAPR),
            " | Timestamp: ", uint2str(b.timestamp),
            " | Blessed: ", b.isBlessed ? "Yes" : "No",
            " | Broadcasted: ", b.isBroadcasted ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
