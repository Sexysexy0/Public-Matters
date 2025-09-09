// SPDX-License-Identifier: SatireContinuity-License
pragma solidity ^0.8.0;

contract ScrollchainSatireContinuityOracle {
    address public steward;

    struct ContinuitySignal {
        string sanctumName;
        uint256 assuranceLevel;
        string pledgeType;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event ContinuityAssuranceEmitted(string sanctumName, uint256 assuranceLevel, string pledgeType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAssurance(string memory sanctumName, uint256 assuranceLevel, string memory pledgeType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(ContinuitySignal(sanctumName, assuranceLevel, pledgeType, block.timestamp));
        emit ContinuityAssuranceEmitted(sanctumName, assuranceLevel, pledgeType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, uint256, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.sanctumName, s.assuranceLevel, s.pledgeType, s.timestamp);
    }

    function totalSignals() public view returns (uint) {
        return signals.length;
    }
}
