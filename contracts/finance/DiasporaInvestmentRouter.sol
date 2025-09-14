// SPDX-License-Identifier: DiasporaSanctum
pragma solidity ^0.8.19;

contract DiasporaInvestmentRouter {
    struct InvestmentCorridor {
        string originCountry;
        string destinationCountry;
        string platformName;
        bool treatyCompliant;
        bool investmentActivated;
    }

    mapping(bytes32 => InvestmentCorridor) public corridors;

    event CorridorLogged(string originCountry, string destinationCountry, string platformName);
    event InvestmentActivated(string originCountry, string destinationCountry, string platformName);

    function logCorridor(
        string memory originCountry,
        string memory destinationCountry,
        string memory platformName,
        bool treatyCompliant
    ) public {
        bytes32 corridorId = keccak256(abi.encodePacked(originCountry, destinationCountry, platformName));
        corridors[corridorId] = InvestmentCorridor(originCountry, destinationCountry, platformName, treatyCompliant, false);
        emit CorridorLogged(originCountry, destinationCountry, platformName);
    }

    function activateInvestment(string memory originCountry, string memory destinationCountry, string memory platformName) public {
        bytes32 corridorId = keccak256(abi.encodePacked(originCountry, destinationCountry, platformName));
        require(corridors[corridorId].treatyCompliant, "Corridor must be treaty-compliant");
        corridors[corridorId].investmentActivated = true;
        emit InvestmentActivated(originCountry, destinationCountry, platformName);
    }

    function isInvestmentActivated(string memory originCountry, string memory destinationCountry, string memory platformName) public view returns (bool) {
        bytes32 corridorId = keccak256(abi.encodePacked(originCountry, destinationCountry, platformName));
        return corridors[corridorId].investmentActivated;
    }
}
