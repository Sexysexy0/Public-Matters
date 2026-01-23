pragma solidity ^0.8.20;

contract ConsumerReliefProtocol {
    address public admin;

    struct Relief {
        string group;        // e.g. households, commuters
        string benefit;      // e.g. cheaper goods, lower fares
        string impact;       // e.g. improved affordability
        uint256 timestamp;
    }

    Relief[] public reliefs;

    event ReliefLogged(string group, string benefit, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRelief(string calldata group, string calldata benefit, string calldata impact) external onlyAdmin {
        reliefs.push(Relief(group, benefit, impact, block.timestamp));
        emit ReliefLogged(group, benefit, impact, block.timestamp);
    }

    function totalReliefs() external view returns (uint256) {
        return reliefs.length;
    }
}
