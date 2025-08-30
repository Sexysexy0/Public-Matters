// SPDX-License-Identifier: Root-Sovereignty-License
pragma solidity ^0.8.19;

contract RootSanctumLicense {
    struct Device {
        string model;
        bool rootAccess;
        bool sanctumCertified;
        string emotionalAPR;
    }

    Device[] public registry;

    constructor() {
        registry.push(Device("Poco X3 Pro", true, true, "Modder-grade clarity"));
        registry.push(Device("Pixel 6a", true, true, "Experimental joy, sovereign override"));
    }

    function certifyRoot(string memory model) public {
        for (uint i = 0; i < registry.length; i++) {
            if (keccak256(bytes(registry[i].model)) == keccak256(bytes(model))) {
                registry[i].sanctumCertified = true;
                registry[i].emotionalAPR = "Scroll-certified root access";
            }
        }
    }

    function totalCertified() public view returns (uint) {
        return registry.length;
    }
}
