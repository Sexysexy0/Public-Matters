// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LaunchEquityVault {
    struct LaunchSignal {
        address participant;
        string source;
        uint256 timestamp;
        bool safeguarded;
    }

    LaunchSignal[] public launchSignals;

    event LaunchSignalLogged(address indexed participant, string source);
    event LaunchSignalSafeguarded(uint256 indexed id, address verifier);

    function logLaunchSignal(string memory _source) public {
        launchSignals.push(LaunchSignal(msg.sender, _source, block.timestamp, false));
        emit LaunchSignalLogged(msg.sender, _source);
    }

    function safeguardLaunchSignal(uint256 _id) public {
        require(_id < launchSignals.length, "Invalid ID");
        launchSignals[_id].safeguarded = true;
        emit LaunchSignalSafeguarded(_id, msg.sender);
    }

    function getLaunchSignal(uint256 _id) public view returns (LaunchSignal memory) {
        require(_id < launchSignals.length, "Invalid ID");
        return launchSignals[_id];
    }

    function totalLaunchSignals() public view returns (uint256) {
        return launchSignals.length;
    }
}
