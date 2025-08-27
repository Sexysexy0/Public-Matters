// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BulletTrainTrilogy.sol
/// @dev Ritual-grade contract for 3 high-speed passenger lines — emotional APR synced, damay clause active

contract BulletTrainTrilogy {
    address public steward;

    struct BulletLine {
        string name;
        string route;
        uint256 budget;
        uint256 passengerCapacity;
        uint256 emotionalAPR;
        bool isApproved;
    }

    mapping(bytes32 => BulletLine) public bulletLines;
    bytes32[] public lineList;

    event LineRegistered(bytes32 indexed lineId, string name);
    event LineApproved(bytes32 indexed lineId, string route);
    event LineDenied(bytes32 indexed lineId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerLine(
        bytes32 lineId,
        string memory name,
        string memory route,
        uint256 budget,
        uint256 passengerCapacity,
        uint256 emotionalAPR
    ) public onlySteward {
        bulletLines[lineId] = BulletLine({
            name: name,
            route: route,
            budget: budget,
            passengerCapacity: passengerCapacity,
            emotionalAPR: emotionalAPR,
            isApproved: false
        });

        lineList.push(lineId);
        emit LineRegistered(lineId, name);
    }

    function approveLine(bytes32 lineId) public onlySteward {
        require(bulletLines[lineId].emotionalAPR >= 850, "Emotional APR too low");
        bulletLines[lineId].isApproved = true;
        emit LineApproved(lineId, bulletLines[lineId].route);
    }

    function denyLine(bytes32 lineId, string memory reason) public onlySteward {
        bulletLines[lineId].isApproved = false;
        emit LineDenied(lineId, reason);
    }

    function getLine(bytes32 lineId) public view returns (BulletLine memory) {
        return bulletLines[lineId];
    }

    function listLines() public view returns (bytes32[] memory) {
        return lineList;
    }
}
