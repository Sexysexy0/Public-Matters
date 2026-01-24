pragma solidity ^0.8.20;

contract CryptoAdvocacyProtocol {
    address public admin;

    struct Advocacy {
        string advocate;     // e.g. Coinbase CEO, Cathy Wood
        string argument;     // e.g. Bitcoin standard, inflation hedge
        string impact;       // e.g. investor confidence, narrative support
        uint256 timestamp;
    }

    Advocacy[] public advocacies;

    event AdvocacyLogged(string advocate, string argument, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAdvocacy(string calldata advocate, string calldata argument, string calldata impact) external onlyAdmin {
        advocacies.push(Advocacy(advocate, argument, impact, block.timestamp));
        emit AdvocacyLogged(advocate, argument, impact, block.timestamp);
    }

    function totalAdvocacies() external view returns (uint256) {
        return advocacies.length;
    }
}
