// SPDX-License-Identifier: EconomicSanctum
pragma solidity ^0.8.19;

contract StimulusOverflowRouter {
    struct OverflowSignal {
        string stewardName;
        string affectedSector; // e.g., "food", "housing", "healthcare", "transport"
        uint256 inflationRate;
        bool stimulusReceived;
        bool overflowDetected;
        bool reliefActivated;
    }

    mapping(address => OverflowSignal) public signals;

    event OverflowLogged(
        address indexed steward,
        string stewardName,
        string affectedSector,
        uint256 inflationRate,
        bool stimulusReceived
    );

    event ReliefActivated(address indexed steward, string affectedSector);

    function logOverflow(
        string memory stewardName,
        string memory affectedSector,
        uint256 inflationRate,
        bool stimulusReceived
    ) public {
        signals[msg.sender] = OverflowSignal(
            stewardName,
            affectedSector,
            inflationRate,
            stimulusReceived,
            true,
            false
        );
        emit OverflowLogged(msg.sender, stewardName, affectedSector, inflationRate, stimulusReceived);
    }

    function activateRelief(address steward) public {
        require(signals[steward].overflowDetected, "No overflow detected");
        signals[steward].reliefActivated = true;
        emit ReliefActivated(steward, signals[steward].affectedSector);
    }

    function getSignal(address steward) public view returns (OverflowSignal memory) {
        return signals[steward];
    }

    function isReliefActivated(address steward) public view returns (bool) {
        return signals[steward].reliefActivated;
    }
}
