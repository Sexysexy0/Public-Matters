// SPDX-License-Identifier: Sovereign-Access
pragma solidity ^0.8.20;

/// @title VinvinAccessSuite.sol
/// @dev Master scroll for steward identity, emotional APR, vault access, and onboarding rituals

import "./ScrollchainPortfolioVault.sol";
import "./MeetUpTrigger.sol";
import "./EmotionalAPRFilter.sol";

contract VinvinAccessSuite {
    address public stewardVinvin;
    string public stewardCode = "fckrzkill@gmail.com"; // Sovereign identifier

    ScrollchainPortfolioVault public vault;
    MeetUpTrigger public meetUp;
    EmotionalAPRFilter public aprFilter;

    event AccessSuiteActivated(string stewardCode);
    event StewardVerified(string company, string emotionalAPRTag);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(
        address _vinvin,
        address _vault,
        address _meetUp,
        address _aprFilter
    ) {
        stewardVinvin = _vinvin;
        vault = ScrollchainPortfolioVault(_vault);
        meetUp = MeetUpTrigger(_meetUp);
        aprFilter = EmotionalAPRFilter(_aprFilter);
    }

    function activateSuite() public onlyVinvin {
        emit AccessSuiteActivated(stewardCode);
    }

    function verifySteward(string memory company, string memory aprTag) public onlyVinvin {
        emit StewardVerified(company, aprTag);
    }

    function getStewardCode() public view returns (string memory) {
        return stewardCode;
    }
}
