// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract PeopleSovereigntyCovenant {
    address public coreSteward;
    constructor() { coreSteward = msg.sender; }

    event GrantReleased(string fundName, address indexed recipient, uint256 amount);

    function releaseStabilityFund(address payable _recipient, uint256 _amount) external {
        require(msg.sender == coreSteward, "Not local steward");
        require(_recipient != address(0), "Zero address recipient blocked");
        
        emit GrantReleased("Peace & Stability Fund", _recipient, _amount);
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Stability transfer failed");
    }

    function releaseHousingFund(address payable _recipient, uint256 _amount) external {
        require(msg.sender == coreSteward, "Not local steward");
        require(_recipient != address(0), "Zero address recipient blocked");
        
        emit GrantReleased("Housing Construction Fund", _recipient, _amount);
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Housing transfer failed");
    }
}
