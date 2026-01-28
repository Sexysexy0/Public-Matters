pragma solidity ^0.8.20;

contract CryptoCapitalProtocol {
    address public admin;

    struct Capital {
        string vision;       // e.g. U.S. as crypto capital
        string driver;       // e.g. Trump administration, CLARITY Act
        string benefit;      // e.g. investor confidence, innovation hub
        uint256 timestamp;
    }

    Capital[] public capitals;

    event CapitalLogged(string vision, string driver, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCapital(string calldata vision, string calldata driver, string calldata benefit) external onlyAdmin {
        capitals.push(Capital(vision, driver, benefit, block.timestamp));
        emit CapitalLogged(vision, driver, benefit, block.timestamp);
    }

    function totalCapitals() external view returns (uint256) {
        return capitals.length;
    }
}
