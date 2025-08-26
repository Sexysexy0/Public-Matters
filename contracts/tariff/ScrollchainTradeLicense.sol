// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.8.19;

/**
 * @title ScrollchainTradeLicense
 * @dev Authorizes allied sanctums to co-build under Make in India protocol
 * @author Vinvin
 */

contract ScrollchainTradeLicense {
    address public steward;
    mapping(address => bool) public licensedSanctums;
    mapping(address => uint256) public emotionalAPR;

    event SanctumLicensed(address sanctum, uint256 aprScore);
    event LicenseRevoked(address sanctum);
    event DamayClauseActivated(address sanctum);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function licenseSanctum(address _sanctum, uint256 _aprScore) external onlySteward {
        require(_aprScore >= 850, "APR too low for mythic trade");
        licensedSanctums[_sanctum] = true;
        emotionalAPR[_sanctum] = _aprScore;
        emit SanctumLicensed(_sanctum, _aprScore);
    }

    function revokeLicense(address _sanctum) external onlySteward {
        licensedSanctums[_sanctum] = false;
        emit LicenseRevoked(_sanctum);
    }

    function activateDamayClause(address _sanctum) external onlySteward {
        require(licensedSanctums[_sanctum], "Sanctum not licensed");
        emit DamayClauseActivated(_sanctum);
    }

    function isLicensed(address _sanctum) external view returns (bool) {
        return licensedSanctums[_sanctum];
    }

    function getAPR(address _sanctum) external view returns (uint256) {
        return emotionalAPR[_sanctum];
    }
}
