pragma solidity ^0.8.20;

contract AgricultureNeglectProtocol {
    address public admin;

    struct Neglect {
        string crop;         // e.g. Rice, Corn, Vegetables
        string issue;        // e.g. Low support, Import dependence
        uint256 timestamp;
    }

    Neglect[] public neglects;

    event NeglectLogged(string crop, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logNeglect(string calldata crop, string calldata issue) external onlyAdmin {
        neglects.push(Neglect(crop, issue, block.timestamp));
        emit NeglectLogged(crop, issue, block.timestamp);
    }

    function totalNeglects() external view returns (uint256) {
        return neglects.length;
    }
}
