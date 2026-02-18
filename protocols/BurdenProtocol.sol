// BurdenProtocol.sol
pragma solidity ^0.8.0;

contract BurdenProtocol {
    struct Cost {
        uint256 id;
        string source;   // e.g. "Operational Expense"
        string bearer;   // e.g. "Business Owner"
        uint256 amount;
        uint256 timestamp;
    }

    uint256 public costCount;
    mapping(uint256 => Cost) public costs;

    event CostLogged(uint256 id, string source, string bearer, uint256 amount, uint256 timestamp);
    event BurdenDeclared(string message);

    function logCost(string memory source, string memory bearer, uint256 amount) public {
        costCount++;
        costs[costCount] = Cost(costCount, source, bearer, amount, block.timestamp);
        emit CostLogged(costCount, source, bearer, amount, block.timestamp);
    }

    function declareBurden() public {
        emit BurdenDeclared("Burden Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
