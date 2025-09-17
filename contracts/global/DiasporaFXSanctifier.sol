// SPDX-License-Identifier: FXSanctum
pragma solidity ^0.8.19;

contract DiasporaFXSanctifier {
    address public steward;

    struct FXCorridor {
        string originCountry;
        string destinationCountry;
        string remittancePlatform;
        string currencyPair;
        uint256 volumeUSD;
        uint256 timestamp;
        bool stabilized;
    }

    FXCorridor[] public corridors;

    event FXLogged(string originCountry, string destinationCountry, string remittancePlatform, string currencyPair, uint256 volumeUSD, uint256 timestamp);
    event FXStabilized(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logFXCorridor(
        string memory originCountry,
        string memory destinationCountry,
        string memory remittancePlatform,
        string memory currencyPair,
        uint256 volumeUSD
    ) public {
        corridors.push(FXCorridor(originCountry, destinationCountry, remittancePlatform, currencyPair, volumeUSD, block.timestamp, false));
        emit FXLogged(originCountry, destinationCountry, remittancePlatform, currencyPair, volumeUSD, block.timestamp);
    }

    function stabilizeFX(uint256 index) public {
        require(index < corridors.length, "Invalid index");
        corridors[index].stabilized = true;
        emit FXStabilized(index, msg.sender);
    }

    function getFXCorridor(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256, uint256, bool
    ) {
        FXCorridor memory c = corridors[index];
        return (c.originCountry, c.destinationCountry, c.remittancePlatform, c.currencyPair, c.volumeUSD, c.timestamp, c.stabilized);
    }

    function totalCorridors() public view returns (uint256) {
        return corridors.length;
    }
}
