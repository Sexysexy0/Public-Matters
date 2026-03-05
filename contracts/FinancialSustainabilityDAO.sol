// FinancialSustainabilityDAO.sol
pragma solidity ^0.8.0;

contract FinancialSustainabilityDAO {
    struct Safeguard {
        uint256 id;
        string measure;   // e.g. "Diversify funding sources"
        string outcome;   // e.g. "Reduced cash burn risk"
        bool active;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardActivated(uint256 id, string measure, string outcome);

    function activateSafeguard(string memory measure, string memory outcome) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, measure, outcome, true);
        emit SafeguardActivated(safeguardCount, measure, outcome);
    }
}
