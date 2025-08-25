// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract JoyIndexParkTracker {
    address public scrollsmith;
    uint256 public totalParkFund = 20_000_000_000 * 1e18; // $20B allocation

    struct Park {
        string city;
        string name;
        uint256 allocated;
        bool completed;
        uint8 joyScore; // 0–100
        uint8 safetyScore;
        string ancestralTag;
        string KinderQueenImpact;
        uint256 timestamp;
    }

    mapping(uint256 => Park) public parks;
    uint256 public nextParkId;

    event ParkRegistered(string city, string name);
    event ParkCompleted(string name);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function registerPark(
        string calldata city,
        string calldata name,
        uint256 allocated,
        uint8 joyScore,
        uint8 safetyScore,
        string calldata ancestralTag,
        string calldata KinderQueenImpact
    ) external onlyScrollsmith {
        require(allocated <= totalParkFund, "Insufficient fund");

        parks[nextParkId] = Park({
            city: city,
            name: name,
            allocated: allocated,
            completed: false,
            joyScore: joyScore,
            safetyScore: safetyScore,
            ancestralTag: ancestralTag,
            KinderQueenImpact: KinderQueenImpact,
            timestamp: block.timestamp
        });

        totalParkFund -= allocated;
        emit ParkRegistered(city, name);
        nextParkId++;
    }

    function markCompleted(uint256 id) external onlyScrollsmith {
        parks[id].completed = true;
        emit ParkCompleted(parks[id].name);
    }
}
