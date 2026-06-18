// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityTokenIncentive
/// @notice Covenant contract to reward providers who comply with fairness and transparency safeguards
/// @dev Issues governance reputation tokens for compliant actors
contract EquityTokenIncentive {
    address public overseer;
    string public tokenName = "Equity Reputation Token";
    string public tokenSymbol = "ERT";
    uint256 public totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => bool) public compliantProviders;

    event ProviderCompliant(address indexed provider, uint256 reward);
    event ProviderRevoked(address indexed provider);
    event Transfer(address indexed from, address indexed to, uint256 value);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer marks provider as compliant and issues reward tokens
    function markCompliant(address provider, uint256 reward) external onlyOverseer {
        compliantProviders[provider] = true;
        balances[provider] += reward;
        totalSupply += reward;
        emit ProviderCompliant(provider, reward);
    }

    /// @notice Overseer revokes compliance status
    function revokeCompliance(address provider) external onlyOverseer {
        compliantProviders[provider] = false;
        emit ProviderRevoked(provider);
    }

    /// @notice Transfer reputation tokens between providers
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    /// @notice Check if provider is compliant
    function isCompliant(address provider) external view returns (bool) {
        return compliantProviders[provider];
    }
}
