pragma solidity ^0.8.20;

contract EliteCaptureProtocol {
    address public admin;

    struct Capture {
        string actor;        // e.g. Political elite, Corporation
        string benefit;      // e.g. Policy control, Market monopoly
        uint256 timestamp;
    }

    Capture[] public captures;

    event CaptureLogged(string actor, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCapture(string calldata actor, string calldata benefit) external onlyAdmin {
        captures.push(Capture(actor, benefit, block.timestamp));
        emit CaptureLogged(actor, benefit, block.timestamp);
    }

    function totalCaptures() external view returns (uint256) {
        return captures.length;
    }
}
