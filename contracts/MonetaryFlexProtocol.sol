pragma solidity ^0.8.20;

contract MonetaryFlexProtocol {
    address public admin;

    struct Flex {
        string tool;         // e.g. fiat expansion, quantitative easing
        string potential;    // e.g. broadened policy imagination, domestic funding leverage
        uint256 timestamp;
    }

    Flex[] public flexes;

    event FlexLogged(string tool, string potential, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFlex(string calldata tool, string calldata potential) external onlyAdmin {
        flexes.push(Flex(tool, potential, block.timestamp));
        emit FlexLogged(tool, potential, block.timestamp);
    }

    function totalFlexes() external view returns (uint256) {
        return flexes.length;
    }
}
