pragma solidity ^0.8.20;

contract CreatorMindsetProtocol {
    address public admin;

    struct Mindset {
        string focus;        // e.g. creation, management
        string benefit;      // e.g. empowerment, resilience
        uint256 timestamp;
    }

    Mindset[] public mindsets;

    event MindsetLogged(string focus, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMindset(string calldata focus, string calldata benefit) external onlyAdmin {
        mindsets.push(Mindset(focus, benefit, block.timestamp));
        emit MindsetLogged(focus, benefit, block.timestamp);
    }

    function totalMindsets() external view returns (uint256) {
        return mindsets.length;
    }
}
