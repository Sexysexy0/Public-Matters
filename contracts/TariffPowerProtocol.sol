pragma solidity ^0.8.20;

contract TariffPowerProtocol {
    address public president;

    struct Tariff {
        string sector;       // e.g. steel, autos, Iran sanctions
        uint256 rate;        // tariff percentage
        uint256 timestamp;
    }

    Tariff[] public tariffs;

    event TariffLogged(string sector, uint256 rate, uint256 timestamp);

    constructor() { president = msg.sender; }

    modifier onlyPresident() { require(msg.sender == president, "Not President"); _; }

    function logTariff(string calldata sector, uint256 rate) external onlyPresident {
        tariffs.push(Tariff(sector, rate, block.timestamp));
        emit TariffLogged(sector, rate, block.timestamp);
    }

    function totalTariffs() external view returns (uint256) {
        return tariffs.length;
    }
}
