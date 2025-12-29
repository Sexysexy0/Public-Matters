// contracts/FederalInterventionCall.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FederalInterventionCall
 * @notice Logs calls for federal intervention in local governance.
 */
contract FederalInterventionCall {
    address public admin;

    struct Call {
        string agency;      // "DOJ", "FederalOversight"
        string reason;      // "InvestigateFunds", "Transparency"
        uint256 timestamp;
    }

    Call[] public calls;

    event CallLogged(string agency, string reason, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCall(string calldata agency, string calldata reason) external onlyAdmin {
        calls.push(Call(agency, reason, block.timestamp));
        emit CallLogged(agency, reason, block.timestamp);
    }

    function totalCalls() external view returns (uint256) { return calls.length; }

    function getCall(uint256 id) external view returns (Call memory) {
        require(id < calls.length, "Invalid id");
        return calls[id];
    }
}
