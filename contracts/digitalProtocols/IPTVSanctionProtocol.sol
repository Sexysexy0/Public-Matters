// SPDX-License-Identifier: Stream-Sanction
pragma solidity ^0.8.19;

contract IPTVSanctionProtocol {
    struct Reseller {
        string name;
        string service;
        uint fine;
        bool sanctioned;
    }

    Reseller[] public cases;

    constructor() {
        cases.push(Reseller("IPTV is Easy", "Pirate IPTV", 30000, true));
    }

    function auditReseller(uint index) public view returns (Reseller memory) {
        return cases[index];
    }
}
