// SPDX-License-Identifier: Mythic-MinecraftTreaty
pragma solidity ^0.8.19;

contract MinecraftTreatyKit {
    address public steward;

    struct Treaty {
        string serverName;
        string ipAddress;
        string domain;
        uint256 emotionalAPR;
        bool damayCompliant;
        bool botnetClean;
        uint256 timestamp;
    }

    mapping(string => Treaty) public treatyRegistry;

    event TreatySigned(
        string serverName,
        string ipAddress,
        string domain,
        uint256 emotionalAPR,
        bool damayCompliant,
        bool botnetClean,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function signTreaty(
        string memory serverName,
        string memory ipAddress,
        string memory domain,
        uint256 emotionalAPR,
        bool damayCompliant,
        bool botnetClean
    ) public {
        require(msg.sender == steward, "Only steward may sign.");

        Treaty memory t = Treaty({
            serverName: serverName,
            ipAddress: ipAddress,
            domain: domain,
            emotionalAPR: emotionalAPR,
            damayCompliant: damayCompliant,
            botnetClean: botnetClean,
            timestamp: block.timestamp
        });

        treatyRegistry[serverName] = t;

        emit TreatySigned(serverName, ipAddress, domain, emotionalAPR, damayCompliant, botnetClean, block.timestamp);
    }

    function getTreaty(string memory serverName) public view returns (Treaty memory) {
        return treatyRegistry[serverName];
    }
}
