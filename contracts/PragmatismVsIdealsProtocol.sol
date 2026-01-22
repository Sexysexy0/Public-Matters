pragma solidity ^0.8.20;

contract PragmatismVsIdealsProtocol {
    address public admin;

    struct Balance {
        string actor;        // e.g. Canada, EU
        string ideal;        // e.g. alliances, values
        string pragmatic;    // e.g. appeasement, stability
        uint256 timestamp;
    }

    Balance[] public balances;

    event BalanceLogged(string actor, string ideal, string pragmatic, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBalance(string calldata actor, string calldata ideal, string calldata pragmatic) external onlyAdmin {
        balances.push(Balance(actor, ideal, pragmatic, block.timestamp));
        emit BalanceLogged(actor, ideal, pragmatic, block.timestamp);
    }

    function totalBalances() external view returns (uint256) {
        return balances.length;
    }
}
