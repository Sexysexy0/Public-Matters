// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarketParticipantRegistry {
    struct Participant {
        address user;
        uint256 registrationTime;
        bool isVerified;
        uint256 totalLosses;
        uint256 totalWins;
        uint256 lossLimit;
    }

    mapping(address => Participant) public participants;
    mapping(address => bool) public isBlacklisted;

    event ParticipantRegistered(address indexed user);
    event LossLimitUpdated(address indexed user, uint256 newLimit);
    event Blacklisted(address indexed user);

    function registerParticipant(uint256 _lossLimit) external {
        require(!isBlacklisted[msg.sender], "User is blacklisted");
        require(!participants[msg.sender].isVerified, "Already registered");
        participants[msg.sender] = Participant({
            user: msg.sender,
            registrationTime: block.timestamp,
            isVerified: true,
            totalLosses: 0,
            totalWins: 0,
            lossLimit: _lossLimit
        });
        emit ParticipantRegistered(msg.sender);
    }

    function updateLossLimit(uint256 _newLimit) external {
        require(participants[msg.sender].isVerified, "Not registered");
        participants[msg.sender].lossLimit = _newLimit;
        emit LossLimitUpdated(msg.sender, _newLimit);
    }

    function blacklistUser(address _user) external {
        // onlyOwner placeholder
        isBlacklisted[_user] = true;
        emit Blacklisted(_user);
    }
}
