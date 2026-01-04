pragma solidity ^0.8.20;

contract RightToRepairCommonsProtocol {
    address public admin;

    struct Repair {
        string device;        // e.g. phone, car, appliance
        string issue;         // e.g. battery, engine, software
        uint256 timestamp;
    }

    Repair[] public repairs;

    event RepairLogged(string device, string issue, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRepair(string calldata device, string calldata issue) external onlyAdmin {
        repairs.push(Repair(device, issue, block.timestamp));
        emit RepairLogged(device, issue, block.timestamp);
    }

    function totalRepairs() external view returns (uint256) {
        return repairs.length;
    }
}
