// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectronTamperDetectionKit {
    struct AppScan {
        string appName;
        bool isAsarTampered;
        string detectedPayload;
    }

    mapping(address => AppScan) public scans;

    function scanApp(
        address _scanner,
        string memory _appName,
        bool _isAsarTampered,
        string memory _detectedPayload
    ) public {
        scans[_scanner] = AppScan(_appName, _isAsarTampered, _detectedPayload);
    }

    function isSafe(address _scanner) public view returns (bool) {
        return !scans[_scanner].isAsarTampered;
    }
}
