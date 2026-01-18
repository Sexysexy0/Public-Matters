pragma solidity ^0.8.20;

contract UnsustainableEconomyProtocol {
    address public admin;

    struct Weakness {
        string reliance;     // e.g. BPO, remittances
        string threat;       // e.g. AI disruption, anti-immigration sentiment
        uint256 timestamp;
    }

    Weakness[] public weaknesses;

    event WeaknessLogged(string reliance, string threat, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWeakness(string calldata reliance, string calldata threat) external onlyAdmin {
        weaknesses.push(Weakness(reliance, threat, block.timestamp));
        emit WeaknessLogged(reliance, threat, block.timestamp);
    }

    function totalWeaknesses() external view returns (uint256) {
        return weaknesses.length;
    }
}
