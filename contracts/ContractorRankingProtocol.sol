pragma solidity ^0.8.20;

contract ContractorRankingProtocol {
    address public admin;

    struct Contractor {
        string name;         // e.g. top 15 firms
        uint256 contractsWon;
        uint256 share;       // e.g. 40% of flagged projects
        uint256 timestamp;
    }

    Contractor[] public contractors;

    event ContractorLogged(string name, uint256 contractsWon, uint256 share, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logContractor(string calldata name, uint256 contractsWon, uint256 share) external onlyAdmin {
        contractors.push(Contractor(name, contractsWon, share, block.timestamp));
        emit ContractorLogged(name, contractsWon, share, block.timestamp);
    }

    function totalContractors() external view returns (uint256) {
        return contractors.length;
    }
}
