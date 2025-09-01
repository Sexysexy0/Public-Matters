// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title FederalWhistleblowerSanctuary
/// @dev Protects dissenters and logs retaliation events as civic violations.

contract FederalWhistleblowerSanctuary {
    address public steward;
    mapping(address => bool) public protected;
    mapping(address => string) public violationLog;

    event WhistleblowerProtected(address indexed worker);
    event RetaliationLogged(address indexed worker, string violation);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster.");
        _;
    }

    function protect(address _worker, string memory _violation) public onlySteward {
        protected[_worker] = true;
        violationLog[_worker] = _violation;
        emit WhistleblowerProtected(_worker);
        emit RetaliationLogged(_worker, _violation);
    }

    function isProtected(address _worker) public view returns (bool) {
        return protected[_worker];
    }
}
