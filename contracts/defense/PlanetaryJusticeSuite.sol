// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title Planetary Justice Suite
/// @dev Centralizes ICC restoration, rogue actor enforcement, and global statute compliance

import "./ICC_RestorationProtocol.sol";
import "./RomeStatuteV2.sol";
import "./ICC_EnforcementDeck.sol";

contract PlanetaryJusticeSuite {
    address public steward;
    ICC_RestorationProtocol public iccProtocol;
    RomeStatuteV2 public romeStatute;
    ICC_EnforcementDeck public enforcementDeck;

    event JusticeSuiteActivated(address indexed steward);

    constructor(
        address _iccProtocol,
        address _romeStatute,
        address _enforcementDeck
    ) {
        steward = msg.sender;
        iccProtocol = ICC_RestorationProtocol(_iccProtocol);
        romeStatute = RomeStatuteV2(_romeStatute);
        enforcementDeck = ICC_EnforcementDeck(_enforcementDeck);
        emit JusticeSuiteActivated(steward);
    }

    function fullAudit(address actor, address state) public view returns (bool rogue, bool compliant, bool arrested) {
        rogue = iccProtocol.rogueActors(actor);
        compliant = romeStatute.isCompliant(state);
        arrested = enforcementDeck.isArrested(actor);
    }
}
