// SPDX-License-Identifier: CannabisEquitySanctum
pragma solidity ^0.8.19;

contract CannabisEquitySanctifier {
    struct EquitySignal {
        string applicantID;
        string communityZone;
        bool historicallyImpacted;
        uint256 equityScore;
        bool licenseGranted;
        string stewardNote;
    }

    mapping(string => EquitySignal) public equityLedger;

    event EquityTagged(string applicantID, uint256 equityScore);
    event LicenseSanctified(string applicantID);

    function tagEquity(string memory applicantID, string memory communityZone, bool historicallyImpacted, uint256 equityScore, string memory stewardNote) public {
        equityLedger[applicantID] = EquitySignal(applicantID, communityZone, historicallyImpacted, equityScore, false, stewardNote);
        emit EquityTagged(applicantID, equityScore);
    }

    function sanctifyLicense(string memory applicantID) public {
        require(equityLedger[applicantID].equityScore >= 80, "Equity score too low");
        equityLedger[applicantID].licenseGranted = true;
        emit LicenseSanctified(applicantID);
    }

    function getEquityStatus(string memory applicantID) public view returns (EquitySignal memory) {
        return equityLedger[applicantID];
    }
}
