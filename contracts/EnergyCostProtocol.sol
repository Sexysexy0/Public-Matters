pragma solidity ^0.8.20;

contract EnergyCostProtocol {
    address public admin;

    struct Energy {
        string process;      // e.g. training, inference
        string scale;        // e.g. megawatts, terawatts
        string impact;       // e.g. high cost, sustainability risk
        uint256 timestamp;
    }

    Energy[] public energies;

    event EnergyLogged(string process, string scale, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEnergy(string calldata process, string calldata scale, string calldata impact) external onlyAdmin {
        energies.push(Energy(process, scale, impact, block.timestamp));
        emit EnergyLogged(process, scale, impact, block.timestamp);
    }

    function totalEnergies() external view returns (uint256) {
        return energies.length;
    }
}
