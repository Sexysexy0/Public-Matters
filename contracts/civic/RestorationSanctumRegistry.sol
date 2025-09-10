// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract RestorationSanctumRegistry {
    struct Sanctum {
        string name;
        string region;
        address steward;
        bool verified;
        uint256 blessingsReceived;
    }

    mapping(address => Sanctum) public sanctums;
    address public registrySteward;

    event SanctumRegistered(string name, string region, address steward);
    event BlessingReceived(address indexed sanctum, uint256 amount);

    modifier onlyRegistrySteward() {
        require(msg.sender == registrySteward, "Unauthorized: Not registry steward");
        _;
    }

    constructor() {
        registrySteward = msg.sender;
    }

    function registerSanctum(address _steward, string memory _name, string memory _region) public onlyRegistrySteward {
        sanctums[_steward] = Sanctum(_name, _region, _steward, true, 0);
        emit SanctumRegistered(_name, _region, _steward);
    }

    function logBlessing(address _sanctum, uint256 _amount) public onlyRegistrySteward {
        require(sanctums[_sanctum].verified, "Sanctum not verified");
        sanctums[_sanctum].blessingsReceived += _amount;
        emit BlessingReceived(_sanctum, _amount);
    }

    function getSanctum(address _steward) public view returns (Sanctum memory) {
        return sanctums[_steward];
    }
}
