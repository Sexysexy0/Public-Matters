pragma solidity ^0.8.20;

contract SubsidySupportProtocol {
    address public admin;

    struct Subsidy {
        string authority;    // e.g. government, energy agency
        string measure;      // e.g. fuel subsidy, excise tax relief
        string effect;       // e.g. lower diesel price, consumer support
        uint256 timestamp;
    }

    Subsidy[] public subsidies;

    event SubsidyLogged(string authority, string measure, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSubsidy(string calldata authority, string calldata measure, string calldata effect) external onlyAdmin {
        subsidies.push(Subsidy(authority, measure, effect, block.timestamp));
        emit SubsidyLogged(authority, measure, effect, block.timestamp);
    }

    function totalSubsidies() external view returns (uint256) {
        return subsidies.length;
    }
}
