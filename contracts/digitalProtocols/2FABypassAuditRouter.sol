// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract TwoFABypassAuditRouter {
    struct Attempt {
        address user;
        string method; // push, SMS, voice
        uint256 timestamp;
        bool intercepted;
    }

    mapping(address => Attempt[]) public auditLog;

    event BreachAttemptLogged(address indexed user, string method, bool intercepted);

    function logAttempt(address _user, string memory _method, bool _intercepted) public {
        auditLog[_user].push(Attempt(_user, _method, block.timestamp, _intercepted));
        emit BreachAttemptLogged(_user, _method, _intercepted);
    }

    function getAttempts(address _user) public view returns (Attempt[] memory) {
        return auditLog[_user];
    }

    function purgeKupal(address _user) public {
        delete auditLog[_user];
    }
}
