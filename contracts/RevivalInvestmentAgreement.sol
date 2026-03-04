// RevivalInvestmentAgreement.sol
pragma solidity ^0.8.0;

contract RevivalInvestmentAgreement {
    struct Investment {
        uint256 id;
        string company;       // e.g. "Closed Factory A"
        string purpose;       // e.g. "Restart operations"
        uint256 amount;       // Capital injected
        bool released;
        uint256 timestamp;
    }

    uint256 public investmentCount;
    mapping(uint256 => Investment) public investments;

    event InvestmentReleased(uint256 id, string company, string purpose, uint256 amount);

    function releaseInvestment(string memory company, string memory purpose, uint256 amount) public {
        investmentCount++;
        investments[investmentCount] = Investment(investmentCount, company, purpose, amount, true, block.timestamp);
        emit InvestmentReleased(investmentCount, company, purpose, amount);
    }
}
