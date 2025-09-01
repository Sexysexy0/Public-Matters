// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumClarityScroll {
    struct FogEvent {
        string sanctum;
        string distortionType;
        uint256 emotionalAPRDrop;
        uint256 timestamp;
        bool clarityRestored;
    }

    FogEvent[] public fogs;

    event FogLogged(
        string sanctum,
        string distortionType,
        uint256 emotionalAPRDrop,
        uint256 timestamp,
        bool clarityRestored
    );

    function logFog(
        string memory _sanctum,
        string memory _distortionType,
        uint256 _emotionalAPRDrop
    ) public {
        bool clarityRestored = (_emotionalAPRDrop < 40);
        uint256 time = block.timestamp;

        fogs.push(FogEvent(_sanctum, _distortionType, _emotionalAPRDrop, time, clarityRestored));
        emit FogLogged(_sanctum, _distortionType, _emotionalAPRDrop, time, clarityRestored);
    }

    function getAllFogEvents() public view returns (FogEvent[] memory) {
        return fogs;
    }
}
