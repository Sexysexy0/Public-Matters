// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EdwardProtocol (Brick #29)
 * @dev Manages maritime fleet commissioning, trade routes, and plunder distribution.
 */
contract EdwardProtocol {
    address public masterCaptain;
    mapping(bytes32 => bool) public activeFleets;
    mapping(address => uint256) public jackdawTreasury;

    event FleetCommissioned(bytes32 indexed fleetId, string route);
    event PlunderDistributed(address indexed crewMember, uint256 share);

    modifier onlyCaptain() {
        require(msg.sender == masterCaptain, "Unauthorized: Only the Master Captain can command this.");
        _;
    }

    constructor() payable {
        masterCaptain = msg.sender;
    }

    receive() external payable {}

    function commissionFleet(bytes32 _fleetId, string calldata _route) external onlyCaptain {
        require(!activeFleets[_fleetId], "Fleet already active");
        activeFleets[_fleetId] = true;
        emit FleetCommissioned(_fleetId, _route);
    }

    function distributePlunder(address payable _crew, uint256 _share) external onlyCaptain {
        require(address(this).balance >= _share, "Insufficient treasury for plunder distribution");
        jackdawTreasury[_crew] += _share;

        (bool success,) = _crew.call{value: _share}("");
        require(success, "Plunder transfer failed");

        emit PlunderDistributed(_crew, _share);
    }
}
