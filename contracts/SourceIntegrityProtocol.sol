pragma solidity ^0.8.20;

contract SourceIntegrityProtocol {
    address public admin;

    struct Source {
        string name;         // e.g. Grokipedia, Wikipedia
        string typeOf;       // e.g. AI-generated, curated
        string risk;         // e.g. misinformation, bias
        uint256 timestamp;
    }

    Source[] public sources;

    event SourceLogged(string name, string typeOf, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSource(string calldata name, string calldata typeOf, string calldata risk) external onlyAdmin {
        sources.push(Source(name, typeOf, risk, block.timestamp));
        emit SourceLogged(name, typeOf, risk, block.timestamp);
    }

    function totalSources() external view returns (uint256) {
        return sources.length;
    }
}
