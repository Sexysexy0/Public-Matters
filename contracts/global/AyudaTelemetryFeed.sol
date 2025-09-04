// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AyudaTelemetryFeed {
    address public steward;

    struct BarangayData {
        uint256 emotionalAPR;
        uint256 ayudaReceived;
        bool isBlessed;
    }

    mapping(string => BarangayData) public barangayFeed;

    event AyudaSynced(string barangay, uint256 amount, uint256 apr);
    event BlessingUpdated(string barangay, bool status);

    constructor() {
        steward = msg.sender;
    }

    function blessBarangay(string memory _name, bool _status) public {
        require(msg.sender == steward, "Only steward may bless");
        barangayFeed[_name].isBlessed = _status;
        emit BlessingUpdated(_name, _status);
    }

    function updateEmotionalAPR(string memory _name, uint256 _score) public {
        require(msg.sender == steward, "Only steward may update APR");
        barangayFeed[_name].emotionalAPR = _score;
    }

    function syncAyuda(string memory _name, uint256 _amount) public {
        require(msg.sender == steward, "Only steward may sync ayuda");
        require(barangayFeed[_name].isBlessed, "Barangay not blessed");
        require(barangayFeed[_name].emotionalAPR >= 75, "APR too low");

        barangayFeed[_name].ayudaReceived += _amount;
        emit AyudaSynced(_name, _amount, barangayFeed[_name].emotionalAPR);
    }

    function getBarangayData(string memory _name) public view returns (uint256 apr, uint256 ayuda, bool blessed) {
        BarangayData memory data = barangayFeed[_name];
        return (data.emotionalAPR, data.ayudaReceived, data.isBlessed);
    }
}
