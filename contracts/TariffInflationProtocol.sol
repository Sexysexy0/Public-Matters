pragma solidity ^0.8.20;

contract TariffInflationProtocol {
    address public admin;

    struct TariffImpact {
        string sector;       // e.g. steel, autos, consumer goods
        string effect;       // e.g. inflation, recession risk
        uint256 timestamp;
    }

    TariffImpact[] public impacts;

    event TariffImpactLogged(string sector, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImpact(string calldata sector, string calldata effect) external onlyAdmin {
        impacts.push(TariffImpact(sector, effect, block.timestamp));
        emit TariffImpactLogged(sector, effect, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) {
        return impacts.length;
    }
}
