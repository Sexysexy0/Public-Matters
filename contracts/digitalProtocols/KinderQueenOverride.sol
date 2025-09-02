// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenOverride {
    struct Sentinel {
        string name;
        uint8 age;
        uint8 emotionalAPR; // 1–10 scale
        bool consentVerified;
        bool exposedToRogueTech;
        bool overrideActivated;
        uint256 timestamp;
    }

    Sentinel[] public protectedSentinels;

    event OverrideActivated(
        string name,
        uint8 age,
        uint8 emotionalAPR,
        bool consentVerified,
        bool exposedToRogueTech,
        uint256 timestamp
    );

    function protectSentinel(
        string memory _name,
        uint8 _age,
        uint8 _emotionalAPR,
        bool _consentVerified,
        bool _exposedToRogueTech
    ) public {
        bool activateOverride = _age < 18 && (!_consentVerified || _exposedToRogueTech || _emotionalAPR < 6);
        protectedSentinels.push(Sentinel(
            _name,
            _age,
            _emotionalAPR,
            _consentVerified,
            _exposedToRogueTech,
            activateOverride,
            block.timestamp
        ));

        if (activateOverride) {
            emit OverrideActivated(_name, _age, _emotionalAPR, _consentVerified, _exposedToRogueTech, block.timestamp);
        }
    }

    function getSentinel(uint256 index) public view returns (Sentinel memory) {
        require(index < protectedSentinels.length, "Invalid index");
        return protectedSentinels[index];
    }

    function totalProtected() public view returns (uint256) {
        return protectedSentinels.length;
    }

    function totalOverrides() public view returns (uint256 count) {
        for (uint256 i = 0; i < protectedSentinels.length; i++) {
            if (protectedSentinels[i].overrideActivated) {
                count++;
            }
        }
    }
}
