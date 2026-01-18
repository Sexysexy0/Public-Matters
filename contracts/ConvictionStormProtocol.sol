pragma solidity ^0.8.20;

contract ConvictionStormProtocol {
    address public admin;

    struct Conviction {
        string narrative;    // e.g. crime conspiracy, collapse
        string intensity;    // e.g. absolute certainty, refusal to downgrade
        uint256 timestamp;
    }

    Conviction[] public convictions;

    event ConvictionLogged(string narrative, string intensity, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConviction(string calldata narrative, string calldata intensity) external onlyAdmin {
        convictions.push(Conviction(narrative, intensity, block.timestamp));
        emit ConvictionLogged(narrative, intensity, block.timestamp);
    }

    function totalConvictions() external view returns (uint256) {
        return convictions.length;
    }
}
