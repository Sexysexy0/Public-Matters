pragma solidity ^0.8.20;

contract TariffImpactProtocol {
    address public admin;

    struct Tariff {
        string policy;       // e.g. Smoot-Hawley, US-China tariffs
        string effect;       // e.g. inflation, consumer burden, cronyism
        string comparison;   // e.g. 1930s vs 2020s
        uint256 timestamp;
    }

    Tariff[] public tariffs;

    event TariffLogged(string policy, string effect, string comparison, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTariff(string calldata policy, string calldata effect, string calldata comparison) external onlyAdmin {
        tariffs.push(Tariff(policy, effect, comparison, block.timestamp));
        emit TariffLogged(policy, effect, comparison, block.timestamp);
    }

    function totalTariffs() external view returns (uint256) {
        return tariffs.length;
    }
}
