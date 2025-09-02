// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ImageConsentOracle.sol";
import "./StalkerAppDetector.sol";

contract DigitalSanctumSuite {
    ImageConsentOracle public imageOracle;
    StalkerAppDetector public stalkerDetector;

    constructor(address _imageOracle, address _stalkerDetector) {
        imageOracle = ImageConsentOracle(_imageOracle);
        stalkerDetector = StalkerAppDetector(_stalkerDetector);
    }

    function verifySanctum(string memory imageHash, string memory appName) public view returns (bool isSafe) {
        bool imageSafe = imageOracle.verifyConsent(imageHash);
        bool appSafe = !stalkerDetector.isStalkerApp(appName);
        return imageSafe && appSafe;
    }
}
