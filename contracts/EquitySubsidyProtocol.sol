pragma solidity ^0.8.20;

contract EquitySubsidyProtocol {
    address public admin;

    struct Subsidy {
        string authority;    // e.g. DOLE, government
        string measure;      // e.g. wage subsidy, tax incentive
        string effect;       // e.g. support equal pay across regions
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
