// InterestBanProtocol.sol
pragma solidity ^0.8.0;

contract InterestBanProtocol {
    struct Transaction {
        uint256 id;
        string party;   // e.g. "Merchant", "Community"
        uint256 amount;
        string feeType; // e.g. "Storage Fee", "Transaction Fee"
        uint256 timestamp;
    }

    uint256 public txCount;
    mapping(uint256 => Transaction) public transactions;

    event TransactionLogged(uint256 id, string party, uint256 amount, string feeType, uint256 timestamp);
    event InterestDeclared(string message);

    function logTransaction(string memory party, uint256 amount, string memory feeType) public {
        txCount++;
        transactions[txCount] = Transaction(txCount, party, amount, feeType, block.timestamp);
        emit TransactionLogged(txCount, party, amount, feeType, block.timestamp);
    }

    function declareInterest() public {
        emit InterestDeclared("Interest Ban Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
