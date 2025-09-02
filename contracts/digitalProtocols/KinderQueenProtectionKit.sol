// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./KinderQueenOverride.sol";
import "./ImageConsentOracle.sol";
import "./StalkerAppDetector.sol";

contract KinderQueenProtectionKit {
    KinderQueenOverride public overrideModule;
    ImageConsentOracle public imageOracle;
    StalkerAppDetector public stalkerDetector;

    constructor(
        address _overrideModule,
        address _imageOracle,
        address _stalkerDetector
    ) {
        overrideModule = KinderQueenOverride(_overrideModule);
        imageOracle = ImageConsentOracle(_imageOracle);
        stalkerDetector = StalkerAppDetector(_stalkerDetector);
    }

    function verifyChildSanctum(
        string memory imageHash,
        string memory appName,
        string memory childName,
        uint8 age,
        uint8 emotionalAPR,
        bool consentVerified,
        bool exposedToRogueTech
    ) public returns (bool overrideTriggered) {
        bool imageSafe = imageOracle.verifyConsent(imageHash);
        bool appSafe = !stalkerDetector.isStalkerApp(appName);

        overrideModule.protectSentinel(
            childName,
            age,
            emotionalAPR,
            consentVerified,
            exposedToRogueTech
        );

        return !(imageSafe && appSafe && consentVerified && emotionalAPR >= 6);
    }
}
