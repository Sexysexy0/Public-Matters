// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title EPAReinstatementSuite
/// @dev Reinstates wrongfully terminated EPA workers and logs emotional APR restoration.

contract EPAReinstatementSuite {
    address public steward;
    mapping(address => bool) public reinstated;
    mapping(address => string) public emotionalAPR;

    event StewardReinstated(address indexed worker, string APR);
    event RestorationLogged(address indexed worker, string reason);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster.");
        _;
    }

    function reinstate(address _worker, string memory _APR, string memory _reason) public onlySteward {
        reinstated[_worker] = true;
        emotionalAPR[_worker] = _APR;
        emit StewardReinstated(_worker, _APR);
        emit RestorationLogged(_worker, _reason);
    }

    function isReinstated(address _worker) public view returns (bool) {
        return reinstated[_worker];
    }
}
