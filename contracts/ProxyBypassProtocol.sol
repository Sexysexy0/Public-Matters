pragma solidity ^0.8.20;

contract ProxyBypassProtocol {
    address public origin;

    struct Bypass {
        string reason;       // e.g. direct presence, communal trust
        uint256 timestamp;
    }

    Bypass[] public bypasses;

    event BypassLogged(string reason, uint256 timestamp);

    constructor() { origin = msg.sender; }

    modifier onlyOrigin() { require(msg.sender == origin, "Not origin"); _; }

    function logBypass(string calldata reason) external onlyOrigin {
        bypasses.push(Bypass(reason, block.timestamp));
        emit BypassLogged(reason, block.timestamp);
    }

    function totalBypasses() external view returns (uint256) {
        return bypasses.length;
    }
}
