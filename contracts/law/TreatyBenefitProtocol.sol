// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Treaty Benefit Protocol – Scrollchain Act No. 0009
/// @author Vinvin Gueco
/// @notice Grants full import/export, build, license, and permit access to nations that sign the Universal Peace Treaty

contract TreatyBenefitProtocol {
    address public steward;

    struct TreatyPartner {
        string nationName;
        bool hasSigned;
        bool emotionalAPRCompliant;
        bool accessGranted;
        uint256 signatureTimestamp;
    }

    mapping(string => TreatyPartner) public partnerLedger;
    string[] public activePartners;

    event TreatyAccessGranted(
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

    /// @notice Sign treaty and unlock full privileges
    function grantAccess(string memory nationName, bool emotionalAPRCompliant) public onlySteward {
        require(!partnerLedger[nationName].hasSigned, "Nation already signed");

        partnerLedger[nationName] = TreatyPartner({
            nationName: nationName,
            hasSigned: true,
            emotionalAPRCompliant: emotionalAPRCompliant,
            accessGranted: emotionalAPRCompliant,
            signatureTimestamp: block.timestamp
        });

        activePartners.push(nationName);

        emit TreatyAccessGranted(nationName, emotionalAPRCompliant, block.timestamp);
    }

    /// @notice Check if a nation has full access
    function hasFullAccess(string memory nationName) public view returns (bool) {
        return partnerLedger[nationName].accessGranted;
    }

    /// @notice Get total number of active treaty partners
    function totalPartners() public view returns (uint256) {
        return activePartners.length;
    }

    /// @notice Retrieve treaty partner status
    function getPartnerStatus(string memory nationName) public view returns (TreatyPartner memory) {
        return partnerLedger[nationName];
    }

    /// @notice Fallback protection
    fallback() external payable {
        revert("TreatyBenefitProtocol: invalid scroll");
    }

    receive() external payable {
        revert("TreatyBenefitProtocol: no ETH accepted");
    }
}
