// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CompassionCircleRouter
 * @notice Engineering solution that automatically redistributes unutilized transaction variance to support peripheral nodes.
 */
contract CompassionCircleRouter {
    event AllocationWidened(address indexed recipient, uint256 redistributedAmountWei);
    event RecipientRegistryUpdated(address indexed recipient, bool isActive);
    event RouterStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public routerSteward;
    uint256 public totalRedistributedVolume;

    // Registry of secondary nodes (the "circle") eligible for auxiliary resource support
    mapping(address => bool) public circleOfCompassion;

    constructor() {
        routerSteward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == routerSteward, "Access Denied: Steward credential validation failed");
        _;
    }

    /**
     * @notice Adds or removes a peripheral node from the active compassion redistribution circle.
     */
    function configureCompassionCircle(address _recipient, bool _status) external onlySteward {
        require(_recipient != address(0), "Parameter Error: Recipient coordinate cannot be empty");
        circleOfCompassion[_recipient] = _status;
        emit RecipientRegistryUpdated(_recipient, _status);
    }

    /**
     * @notice Core Execution Solution: Routes unutilized resource variance to the wider circle of supported addresses.
     * @param _targetRecipient The destination address chosen for resource distribution.
     * @param _amountWei The specific volume of native assets to be redistributed.
     */
    function widenCompassionCircle(address payable _targetRecipient, uint256 _amountWei) external onlySteward {
        require(circleOfCompassion[_targetRecipient], "Policy Intercept: Target coordinate is not inside the registered compassion circle");
        require(address(this).balance >= _amountWei, "Vault Exception: Insufficient native liquidity to fulfill distribution request");

        totalRedistributedVolume += _amountWei;
        _targetRecipient.transfer(_amountWei);

        emit AllocationWidened(_targetRecipient, _amountWei);
    }

    /**
     * @notice Gateway allowing this contract to serve as an asset reservoir for unutilized pipeline scraps.
     */
    receive() external payable {}

    /**
     * @notice Shift the master core cryptographic consensus reference anchor destination.
     */
    function transferRouterSteward(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Identity Error: Target coordinate destination falls outside legal registry dimensions");
        routerSteward = _newSteward;
        emit RouterStewardTransferred(msg.sender, _newSteward);
    }
}
