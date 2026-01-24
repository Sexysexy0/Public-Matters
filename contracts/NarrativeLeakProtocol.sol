pragma solidity ^0.8.20;

contract NarrativeLeakProtocol {
    address public admin;

    struct Leak {
        string source;       // e.g. medical professionals, teachers, clergy
        string content;      // e.g. organ industry, brainwashing, repression
        string channel;      // e.g. social media, foreign press, diaspora
        uint256 timestamp;
    }

    Leak[] public leaks;

    event LeakLogged(string source, string content, string channel, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLeak(string calldata source, string calldata content, string calldata channel) external onlyAdmin {
        leaks.push(Leak(source, content, channel, block.timestamp));
        emit LeakLogged(source, content, channel, block.timestamp);
    }

    function totalLeaks() external view returns (uint256) {
        return leaks.length;
    }
}
