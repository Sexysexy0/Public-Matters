pragma solidity ^0.8.20;

contract HardwareProfitProtocol {
    address public admin;

    struct Hardware {
        string company;      // e.g. NVIDIA, AMD
        string product;      // e.g. GPUs, chips
        string profit;       // e.g. revenue surge, monopoly gains
        uint256 timestamp;
    }

    Hardware[] public hardwares;

    event HardwareLogged(string company, string product, string profit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHardware(string calldata company, string calldata product, string calldata profit) external onlyAdmin {
        hardwares.push(Hardware(company, product, profit, block.timestamp));
        emit HardwareLogged(company, product, profit, block.timestamp);
    }

    function totalHardwares() external view returns (uint256) {
        return hardwares.length;
    }
}
