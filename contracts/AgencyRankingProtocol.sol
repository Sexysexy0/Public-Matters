pragma solidity ^0.8.20;

contract AgencyRankingProtocol {
    address public admin;

    struct Ranking {
        string criteria;     // e.g. country protection, projecting power, assassinations
        string topAgency;    // e.g. CIA, Mossad, MSS
        string order;        // e.g. CIA -> Mossad -> RAW -> MSS -> ISI
        uint256 timestamp;
    }

    Ranking[] public rankings;

    event RankingLogged(string criteria, string topAgency, string order, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRanking(string calldata criteria, string calldata topAgency, string calldata order) external onlyAdmin {
        rankings.push(Ranking(criteria, topAgency, order, block.timestamp));
        emit RankingLogged(criteria, topAgency, order, block.timestamp);
    }

    function totalRankings() external view returns (uint256) {
        return rankings.length;
    }
}
