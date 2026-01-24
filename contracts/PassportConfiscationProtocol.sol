pragma solidity ^0.8.20;

contract PassportConfiscationProtocol {
    address public admin;

    struct Confiscation {
        string group;        // e.g. teachers, doctors, ordinary citizens
        string authority;    // e.g. employer, community org
        string reason;       // e.g. security, control, illegal seizure
        uint256 timestamp;
    }

    Confiscation[] public confiscations;

    event ConfiscationLogged(string group, string authority, string reason, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConfiscation(string calldata group, string calldata authority, string calldata reason) external onlyAdmin {
        confiscations.push(Confiscation(group, authority, reason, block.timestamp));
        emit ConfiscationLogged(group, authority, reason, block.timestamp);
    }

    function totalConfiscations() external view returns (uint256) {
        return confiscations.length;
    }
}
