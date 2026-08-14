// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegulatoryCompliance {
    struct ComplianceConfig {
        uint256 maxBetPerUser;
        uint256 dailyLossLimit;
        uint256 totalLossLimit;
        bool isPaused;
    }

    ComplianceConfig public config;
    mapping(address => uint256) public dailyLoss;
    mapping(address => uint256) public totalLoss;
    mapping(address => uint256) public lastReset;

    event ComplianceUpdated(string key, uint256 value);
    event CompliancePaused(bool isPaused);

    constructor() {
        config = ComplianceConfig({
            maxBetPerUser: 100 ether,
            dailyLossLimit: 50 ether,
            totalLossLimit: 500 ether,
            isPaused: false
        });
    }

    function checkCompliance(address _user, uint256 _amount, bool _isLoss) external {
        require(!config.isPaused, "Market is paused for compliance review");
        require(_amount <= config.maxBetPerUser, "Exceeds max bet per user");

        if (block.timestamp - lastReset[_user] > 1 days) {
            dailyLoss[_user] = 0;
            lastReset[_user] = block.timestamp;
        }

        if (_isLoss) {
            dailyLoss[_user] += _amount;
            totalLoss[_user] += _amount;
            require(dailyLoss[_user] <= config.dailyLossLimit, "Exceeds daily loss limit");
            require(totalLoss[_user] <= config.totalLossLimit, "Exceeds total loss limit");
        }
    }

    function updateConfig(uint256 _maxBet, uint256 _dailyLoss, uint256 _totalLoss) external {
        // onlyOwner placeholder
        config.maxBetPerUser = _maxBet;
        config.dailyLossLimit = _dailyLoss;
        config.totalLossLimit = _totalLoss;
        emit ComplianceUpdated("maxBet", _maxBet);
    }

    function togglePause() external {
        // onlyOwner placeholder
        config.isPaused = !config.isPaused;
        emit CompliancePaused(config.isPaused);
    }
}
