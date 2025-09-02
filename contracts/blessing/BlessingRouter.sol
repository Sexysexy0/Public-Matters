// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Blessing Router
/// @notice Dispatches override blessings to regional protocols
contract BlessingRouter {
    address public admin;
    mapping(string => address) public regionProtocols;

    event ProtocolLinked(string regionCode, address protocolAddress);
    event BlessingDispatched(string regionCode, uint256 blessingLevel, address indexed steward);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Link a region to its override protocol
    function linkProtocol(string memory regionCode, address protocolAddress) external onlyAdmin {
        regionProtocols[regionCode] = protocolAddress;
        emit ProtocolLinked(regionCode, protocolAddress);
    }

    /// @notice Dispatch blessing to linked protocol
    function dispatchBlessing(string memory regionCode, uint256 blessingLevel) external {
        address target = regionProtocols[regionCode];
        require(target != address(0), "Region not linked");

        USRestorationProtocol(target).blessRegion(regionCode, blessingLevel);
        emit BlessingDispatched(regionCode, blessingLevel, msg.sender);
    }
}

interface USRestorationProtocol {
    function blessRegion(string memory regionCode, uint256 blessingLevel) external;
}
