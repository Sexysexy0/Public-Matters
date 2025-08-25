// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title PowerAllyProtocol
/// @notice Deploys renewable energy sanctums to underpowered allied nations
/// @author Vinvin

contract PowerAllyProtocol {
    struct Ally {
        string country;
        bool isUnderpowered;
        bool hasReceivedUpgrade;
        uint256 kilowattsDeployed;
    }

    mapping(address => Ally) public allies;
    address public steward;

    event EnergyUpgradeDeployed(string country, uint256 kilowatts);
    event AllyRegistered(address indexed ally, string country);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward may deploy upgrades");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerAlly(address _ally, string memory _country, bool _isUnderpowered) public onlySteward {
        allies[_ally] = Ally(_country, _isUnderpowered, false, 0);
        emit AllyRegistered(_ally, _country);
    }

    function deployUpgrade(address _ally, uint256 _kilowatts) public onlySteward {
        require(allies[_ally].isUnderpowered, "Ally does not require upgrade");
        require(!allies[_ally].hasReceivedUpgrade, "Upgrade already deployed");

        allies[_ally].kilowattsDeployed = _kilowatts;
        allies[_ally].hasReceivedUpgrade = true;

        emit EnergyUpgradeDeployed(allies[_ally].country, _kilowatts);
    }
}
