// SPDX-License-Identifier: SanctumFirewall
pragma solidity ^0.8.19;

contract FirewallBlessingSanctifier {
    struct FirewallSignal {
        string serviceName;
        string cveID;
        bool patched;
        string stewardNote;
    }

    mapping(string => FirewallSignal) public firewallRegistry;

    event ServiceTagged(string serviceName, string cveID);
    event ServiceSanctified(string serviceName);

    function tagService(string memory serviceName, string memory cveID, string memory stewardNote) public {
        firewallRegistry[serviceName] = FirewallSignal(serviceName, cveID, false, stewardNote);
        emit ServiceTagged(serviceName, cveID);
    }

    function sanctifyService(string memory serviceName) public {
        require(bytes(firewallRegistry[serviceName].cveID).length > 0, "Service not tagged");
        firewallRegistry[serviceName].patched = true;
        emit ServiceSanctified(serviceName);
    }

    function getServiceStatus(string memory serviceName) public view returns (FirewallSignal memory) {
        return firewallRegistry[serviceName];
    }
}
