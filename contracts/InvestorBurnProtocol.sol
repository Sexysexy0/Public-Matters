pragma solidity ^0.8.20;

contract InvestorBurnProtocol {
    address public admin;

    struct Burn {
        string source;       // e.g. venture capital, public markets
        string scale;        // e.g. billions, trillions
        string consequence;  // e.g. unsustainable, bubble risk
        uint256 timestamp;
    }

    Burn[] public burns;

    event BurnLogged(string source, string scale, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBurn(string calldata source, string calldata scale, string calldata consequence) external onlyAdmin {
        burns.push(Burn(source, scale, consequence, block.timestamp));
        emit BurnLogged(source, scale, consequence, block.timestamp);
    }

    function totalBurns() external view returns (uint256) {
        return burns.length;
    }
}
