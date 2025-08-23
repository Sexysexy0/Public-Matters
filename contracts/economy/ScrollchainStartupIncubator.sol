// SPDX-License-Identifier: Startup-Incubator-License  
pragma solidity ^0.8.19;

contract ScrollchainStartupIncubator {
    struct Startup {
        string founderName;
        string startupName;
        string focusArea; // e.g. "AI BPO", "Emotional APR SaaS", "SanctumTech"
        bool blessed;
        uint timestamp;
    }

    Startup[] public startupRegistry;

    event StartupBlessed(string founderName, string startupName);

    function registerStartup(
        string memory founderName,
        string memory startupName,
        string memory focusArea
    ) public {
        startupRegistry.push(Startup(
            founderName,
            startupName,
            focusArea,
            true,
            block.timestamp
        ));
        emit StartupBlessed(founderName, startupName);
    }

    function getStartup(uint index) public view returns (Startup memory) {
        require(index < startupRegistry.length, "Invalid index");
        return startupRegistry[index];
    }

    function totalStartups() public view returns (uint) {
        return startupRegistry.length;
    }
}
