// SPDX-License-Identifier: SignalSanctifier
pragma solidity ^0.8.19;

contract SignalSanctifier {
    address public steward;

    struct InfectionSignal {
        string packageName; // e.g. "rxnt-authentication"
        string threatName;  // e.g. "Shai-hulud"
        string corridorTag; // e.g. "NPM", "OpenSource"
        bool verified;
        uint256 timestamp;
    }

    InfectionSignal[] public signals;

    event InfectionLogged(string packageName, string threatName, string corridorTag, uint256 timestamp);
    event InfectionVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logInfection(
        string memory packageName,
        string memory threatName,
        string memory corridorTag
    ) public {
        signals.push(InfectionSignal(packageName, threatName, corridorTag, false, block.timestamp));
        emit InfectionLogged(packageName, threatName, corridorTag, block.timestamp);
    }

    function verifyInfection(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit InfectionVerified(index, msg.sender);
    }

    function totalInfectionSignals() public view returns (uint256) {
        return signals.length;
    }
}
