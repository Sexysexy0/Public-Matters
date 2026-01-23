pragma solidity ^0.8.20;

contract BorrowerReliefProtocol {
    address public admin;

    struct Relief {
        string benefit;      // e.g. lower interest charges
        string risk;         // e.g. tighter approvals, reduced limits
        string impact;       // e.g. household debt relief
        uint256 timestamp;
    }

    Relief[] public reliefs;

    event ReliefLogged(string benefit, string risk, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRelief(string calldata benefit, string calldata risk, string calldata impact) external onlyAdmin {
        reliefs.push(Relief(benefit, risk, impact, block.timestamp));
        emit ReliefLogged(benefit, risk, impact, block.timestamp);
    }

    function totalReliefs() external view returns (uint256) {
        return reliefs.length;
    }
}
