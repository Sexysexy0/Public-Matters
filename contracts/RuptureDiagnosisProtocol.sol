pragma solidity ^0.8.20;

contract RuptureDiagnosisProtocol {
    address public admin;

    struct Rupture {
        string order;        // e.g. rules-based world order
        string cause;        // e.g. weaponized tariffs, supply chains
        string effect;       // e.g. breakdown, coercion
        uint256 timestamp;
    }

    Rupture[] public ruptures;

    event RuptureLogged(string order, string cause, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRupture(string calldata order, string calldata cause, string calldata effect) external onlyAdmin {
        ruptures.push(Rupture(order, cause, effect, block.timestamp));
        emit RuptureLogged(order, cause, effect, block.timestamp);
    }

    function totalRuptures() external view returns (uint256) {
        return ruptures.length;
    }
}
