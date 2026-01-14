pragma solidity ^0.8.20;

contract SupplyChainRestructureProtocol {
    address public admin;

    struct Restructure {
        string sector;       // e.g. energy, tech, manufacturing
        string action;       // e.g. relocation, diversification
        uint256 timestamp;
    }

    Restructure[] public restructures;

    event RestructureLogged(string sector, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRestructure(string calldata sector, string calldata action) external onlyAdmin {
        restructures.push(Restucture(sector, action, block.timestamp));
        emit RestructureLogged(sector, action, block.timestamp);
    }

    function totalRestructures() external view returns (uint256) {
        return restructures.length;
    }
}
