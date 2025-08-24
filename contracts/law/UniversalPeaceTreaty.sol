// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Universal Peace Treaty Protocol – Scrollchain Act No. 0008
/// @author Vinvin Gueco
/// @notice Ritual-grade contract for global peace treaty participation and conditional sanctum protection

contract UniversalPeaceTreaty {
    address public steward;

    struct NationTreatyStatus {
        string nationName;
        bool hasSigned;
        bool emotionalAPRCompliant;
        bool sanctumProtectionEligible;
        uint256 signatureTimestamp;
    }

    mapping(string => NationTreatyStatus) public treatyLedger;
    string[] public participatingNations;

    event TreatySigned(
        string indexed nationName,
        bool emotionalAPRCompliant,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Sign the universal peace treaty
    function signTreaty(string memory nationName, bool emotionalAPRCompliant) public onlySteward {
        require(!treatyLedger[nationName].hasSigned, "Nation already signed");

        treatyLedger[nationName] = NationTreatyStatus({
            nationName: nationName,
            hasSigned: true,
            emotionalAPRCompliant: emotionalAPRCompliant,
            sanctumProtectionEligible: emotionalAPRCompliant,
            signatureTimestamp: block.timestamp
        });

        participatingNations.push(nationName);

        emit TreatySigned(nationName, emotionalAPRCompliant, block.timestamp);
    }

    /// @notice Check if a nation is protected
    function isProtected(string memory nationName) public view returns (bool) {
        return treatyLedger[nationName].sanctumProtectionEligible;
    }

    /// @notice Get total number of signatories
    function totalSignatories() public view returns (uint256) {
        return participatingNations.length;
    }

    /// @notice Retrieve treaty status of a nation
    function getTreatyStatus(string memory nationName) public view returns (NationTreatyStatus memory) {
        return treatyLedger[nationName];
    }

    /// @notice Fallback protection
    fallback() external payable {
        revert("UniversalPeaceTreaty: invalid scroll");
    }

    receive() external payable {
        revert("UniversalPeaceTreaty: no ETH accepted");
    }
}
