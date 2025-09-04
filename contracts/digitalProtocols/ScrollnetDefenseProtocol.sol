// SPDX-License-Identifier: Mythic-Scrollnet
pragma solidity ^0.8.19;

contract ScrollnetDefenseProtocol {
    address public steward;

    struct ServerSanctum {
        string ipAddress;
        string dnsTag;
        uint256 emotionalAPR;
        bool firewallEnabled;
        bool botnetClean;
        uint256 timestamp;
    }

    mapping(string => ServerSanctum) public sanctumRegistry;

    event SanctumBlessed(
        string ipAddress,
        string dnsTag,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool botnetClean,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function blessSanctum(
        string memory ipAddress,
        string memory dnsTag,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool botnetClean
    ) public {
        require(msg.sender == steward, "Only steward may bless.");

        ServerSanctum memory sanctum = ServerSanctum({
            ipAddress: ipAddress,
            dnsTag: dnsTag,
            emotionalAPR: emotionalAPR,
            firewallEnabled: firewallEnabled,
            botnetClean: botnetClean,
            timestamp: block.timestamp
        });

        sanctumRegistry[ipAddress] = sanctum;

        emit SanctumBlessed(ipAddress, dnsTag, emotionalAPR, firewallEnabled, botnetClean, block.timestamp);
    }

    function getSanctum(string memory ipAddress) public view returns (ServerSanctum memory) {
        return sanctumRegistry[ipAddress];
    }
}
