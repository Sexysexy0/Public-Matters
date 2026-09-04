// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract NexusID {
    address public admin;
    mapping(address => bool) public verified;

    event UserVerified(address indexed user);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function verify(address _user) public onlyAdmin {
        verified[_user] = true;
        emit UserVerified(_user);
    }

    function revoke(address _user) public onlyAdmin {
        verified[_user] = false;
    }

    function isVerified(address _user) public view returns (bool) {
        return verified[_user];
    }
}
