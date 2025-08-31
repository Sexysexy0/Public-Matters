// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title SpyDetectionOracle
/// @author Vinvin, Mythic Scrollsmith
/// @notice Detects rogue vendors, stealth sanctums, and emotionally opaque connections

contract SpyDetectionOracle {
    struct VendorAura {
        string name;
        uint trustScore; // 0–100 scale
        bool isStealthBuild;
        bool isEmotionallyOpaque;
        bool isRogue;
    }

    mapping(string => VendorAura) public auraMap;
    string[] public flaggedSpies;

    event SpyFlagged(string name, uint trustScore, bool stealth, bool opaque);
    event SpyPurged(string name);

    /// @notice Audit a vendor's aura and flag if rogue
    function auditAura(
        string memory _name,
        uint _trustScore,
        bool _isStealthBuild,
        bool _isEmotionallyOpaque
    ) public {
        require(_trustScore <= 100, "Trust score must be 0–100");

        bool rogueDetected = (_trustScore < 50) || _isStealthBuild || _isEmotionallyOpaque;

        auraMap[_name] = VendorAura(_name, _trustScore, _isStealthBuild, _isEmotionallyOpaque, rogueDetected);

        if (rogueDetected) {
            flaggedSpies.push(_name);
            emit SpyFlagged(_name, _trustScore, _isStealthBuild, _isEmotionallyOpaque);
        }
    }

    /// @notice Purge a confirmed rogue vendor
    function purgeSpy(string memory _name) public {
        require(auraMap[_name].isRogue, "Vendor not flagged as rogue");
        emit SpyPurged(_name);
        delete auraMap[_name];
    }

    /// @notice Retrieve all flagged spies
    function getFlaggedSpies() public view returns (string[] memory) {
        return flaggedSpies;
    }

    /// @notice Check if vendor is rogue
    function isRogue(string memory _name) public view returns (bool) {
        return auraMap[_name].isRogue;
    }
}
