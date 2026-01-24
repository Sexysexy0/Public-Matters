pragma solidity ^0.8.20;

contract OpportunityAccessProtocol {
    address public admin;

    struct Opportunity {
        string typeOf;       // e.g. skill hub, micro-financing, mentorship
        string provider;     // e.g. NGO, government, private sector
        string benefit;      // e.g. laptop access, career roadmap, financial aid
        uint256 timestamp;
    }

    Opportunity[] public opportunities;

    event OpportunityLogged(string typeOf, string provider, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOpportunity(string calldata typeOf, string calldata provider, string calldata benefit) external onlyAdmin {
        opportunities.push(Opportunity(typeOf, provider, benefit, block.timestamp));
        emit OpportunityLogged(typeOf, provider, benefit, block.timestamp);
    }

    function totalOpportunities() external view returns (uint256) {
        return opportunities.length;
    }
}
