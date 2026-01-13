pragma solidity ^0.8.20;

contract NationalSecurityTariffProtocol {
    address public admin;

    struct Tariff {
        string sector;       // e.g. steel, AI, autos
        uint256 rate;        // tariff percentage
        uint256 timestamp;
    }

    Tariff[] public tariffs;

    event TariffLogged(string sector, uint256 rate, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTariff(string calldata sector, uint256 rate) external onlyAdmin {
        tariffs.push(Tariff(sector, rate, block.timestamp));
        emit TariffLogged(sector, rate, block.timestamp);
    }

    function totalTariffs() external view returns (uint256) {
        return tariffs.length;
    }
}
