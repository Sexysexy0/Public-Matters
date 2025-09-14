// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract ZeroTariffSanctifier {
    struct TradeCorridor {
        string countryA;
        string countryB;
        bool tariffImposed;
        bool treatyCompliant;
        bool zeroTariffCertified;
    }

    mapping(bytes32 => TradeCorridor) public corridors;

    event CorridorLogged(string countryA, string countryB, bool tariffImposed, bool treatyCompliant);
    event ZeroTariffActivated(string countryA, string countryB);

    function logCorridor(
        string memory countryA,
        string memory countryB,
        bool tariffImposed,
        bool treatyCompliant
    ) public {
        bytes32 corridorId = keccak256(abi.encodePacked(countryA, countryB));
        corridors[corridorId] = TradeCorridor(countryA, countryB, tariffImposed, treatyCompliant, false);
        emit CorridorLogged(countryA, countryB, tariffImposed, treatyCompliant);
    }

    function activateZeroTariff(string memory countryA, string memory countryB) public {
        bytes32 corridorId = keccak256(abi.encodePacked(countryA, countryB));
        require(corridors[corridorId].treatyCompliant, "Corridor must be treaty-compliant");
        corridors[corridorId].zeroTariffCertified = true;
        emit ZeroTariffActivated(countryA, countryB);
    }

    function isZeroTariff(string memory countryA, string memory countryB) public view returns (bool) {
        bytes32 corridorId = keccak256(abi.encodePacked(countryA, countryB));
        return corridors[corridorId].zeroTariffCertified;
    }
}
