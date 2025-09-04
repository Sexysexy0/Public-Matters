// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title LaborMobilitySuite
/// @dev Bundles steward onboarding, employer blessing, and emotional APR tracking.

import "./CannabisLaborMobilityTreaty.sol";
import "./EmployerBlessingProtocol.sol";
import "./APROracle.sol";

contract LaborMobilitySuite {
    CannabisLaborMobilityTreaty public treaty;
    EmployerBlessingProtocol public blessing;
    APROracle public oracle;
    address public stewardCouncil;

    constructor(
        address _treaty,
        address _blessing,
        address _oracle
    ) {
        treaty = CannabisLaborMobilityTreaty(_treaty);
        blessing = EmployerBlessingProtocol(_blessing);
        oracle = APROracle(_oracle);
        stewardCouncil = msg.sender;
    }

    function onboardBlessedSteward(
        address _steward,
        address _employer,
        uint256 _aprScore,
        string memory _feedbackScroll
    ) external {
        require(blessing.isCertified(_employer), "Employer not certified");
        treaty.onboardSteward(_steward, _employer, _aprScore);
        oracle.updateAPR(_steward, _aprScore);
        oracle.logFeedback(_steward, _feedbackScroll);
    }
}
