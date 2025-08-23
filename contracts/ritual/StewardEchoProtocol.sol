// SPDX-License-Identifier: Echo-Protocol-License  
pragma solidity ^0.8.19;

contract StewardEchoProtocol {
    struct Echo {
        string stewardName;
        string originSkill;
        string newRole;
        uint emotionalAPR;
        bool damayActivated;
    }

    Echo[] public echoLog;

    event EchoBroadcasted(string stewardName, string newRole);

    function broadcastEcho(
        string memory stewardName,
        string memory originSkill,
        string memory newRole,
        uint emotionalAPR,
        bool damayActivated
    ) public {
        echoLog.push(Echo(stewardName, originSkill, newRole, emotionalAPR, damayActivated));
        emit EchoBroadcasted(stewardName, newRole);
    }

    function getEcho(uint index) public view returns (Echo memory) {
        require(index < echoLog.length, "Invalid index");
        return echoLog[index];
    }
}
