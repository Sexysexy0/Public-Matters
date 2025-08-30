// SanctumVault.sol  
// Mythic vault for storing trusted submodules and config snapshots

pragma solidity ^0.8.0;

contract SanctumVault {
    address public steward;
    string[] public verifiedSubmodules;
    mapping(string => string) public configSnapshots;

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized vault access");
        _;
    }

    function storeSubmodule(string memory name) public onlySteward {
        verifiedSubmodules.push(name);
    }

    function snapshotConfig(string memory name, string memory config) public onlySteward {
        configSnapshots[name] = config;
    }

    function getConfig(string memory name) public view returns (string memory) {
        return configSnapshots[name];
    }
}
