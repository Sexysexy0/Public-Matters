// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title APROracle
/// @author Vinvin
/// @notice Tracks emotional APR (empathy, trust, mythic clarity) for vendors and stewards

contract APROracle {
    struct EmotionalProfile {
        string name;
        uint empathy; // 0–100
        uint trust;   // 0–100
        uint clarity; // 0–100
        uint APR;     // Calculated score
    }

    mapping(string => EmotionalProfile) public profiles;

    event APRUpdated(string name, uint APR);

    /// @notice Update emotional metrics and calculate APR
    function updateProfile(
        string memory _name,
        uint _empathy,
        uint _trust,
        uint _clarity
    ) public {
        require(_empathy <= 100 && _trust <= 100 && _clarity <= 100, "Metrics must be 0–100");

        uint apr = (_empathy + _trust + _clarity) / 3;

        profiles[_name] = EmotionalProfile(_name, _empathy, _trust, _clarity, apr);
        emit APRUpdated(_name, apr);
    }

    /// @notice Get APR of a profile
    function getAPR(string memory _name) public view returns (uint) {
        return profiles[_name].APR;
    }

    /// @notice Get full emotional profile
    function getProfile(string memory _name) public view returns (
        uint empathy, uint trust, uint clarity, uint apr
    ) {
        EmotionalProfile memory p = profiles[_name];
        return (p.empathy, p.trust, p.clarity, p.APR);
    }
}
