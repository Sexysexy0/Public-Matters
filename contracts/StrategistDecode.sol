// contracts/StrategistDecode.sol
pragma solidity ^0.8.20;

/**
 * @title StrategistDecode
 * @notice Logs strategist interpretations based on observed patterns.
 */
contract StrategistDecode {
    address public admin;

    struct Decode {
        string strategist;
        string interpretation;
        uint256 timestamp;
    }

    Decode[] public decodes;

    event DecodeLogged(string strategist, string interpretation, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logDecode(string calldata strategist, string calldata interpretation) external onlyAdmin {
        decodes.push(Decode(strategist, interpretation, block.timestamp));
        emit DecodeLogged(strategist, interpretation, block.timestamp);
    }
}
