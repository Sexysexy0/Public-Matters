// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BlessingRedirectProtocol.sol";

/// @title BlessingRedirectFactory
/// @notice Ritualizes deployment of BlessingRedirectProtocol instances with unique safes
contract BlessingRedirectFactory {
    address public immutable steward;
    address[] public deployedScrolls;

    event ScrollDeployed(address indexed scrollAddress, address indexed blessingSafe);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Deploys a new BlessingRedirectProtocol instance
    /// @param blessingSafe The safe address to receive redirected blessings
    /// @return scrollAddress The address of the newly deployed contract
    function deployScroll(address blessingSafe) external onlySteward returns (address scrollAddress) {
        require(blessingSafe != address(0), "Invalid blessingSafe");

        BlessingRedirectProtocol scroll = new BlessingRedirectProtocol(blessingSafe);
        scrollAddress = address(scroll);
        deployedScrolls.push(scrollAddress);

        emit ScrollDeployed(scrollAddress, blessingSafe);
    }

    /// @notice Returns all deployed scroll addresses
    function getAllScrolls() external view returns (address[] memory) {
        return deployedScrolls;
    }
}
