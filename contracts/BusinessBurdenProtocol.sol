pragma solidity ^0.8.20;

contract BusinessBurdenProtocol {
    address public admin;

    struct Burden {
        string businessType; // e.g. SME, restaurant, retail
        uint256 oldFee;      // e.g. 3000
        uint256 newFee;      // e.g. 36000
        string impact;       // e.g. unsustainable, unfair
        uint256 timestamp;
    }

    Burden[] public burdens;

    event BurdenLogged(string businessType, uint256 oldFee, uint256 newFee, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBurden(string calldata businessType, uint256 oldFee, uint256 newFee, string calldata impact) external onlyAdmin {
        burdens.push(Burden(businessType, oldFee, newFee, impact, block.timestamp));
        emit BurdenLogged(businessType, oldFee, newFee, impact, block.timestamp);
    }

    function totalBurdens() external view returns (uint256) {
        return burdens.length;
    }
}
