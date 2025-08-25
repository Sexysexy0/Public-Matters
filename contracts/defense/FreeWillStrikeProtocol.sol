// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FreeWillStrikeProtocol
/// @dev Allows autonomous strike logic with emotional APR audit and planetary override

contract FreeWillStrikeProtocol {
    address public steward;
    uint256 public strikeCounter;

    struct StrikeIntent {
        uint256 id;
        string target;
        string reason;
        bool isAuthorized;
        string emotionalAPR;
        string damayClause;
    }

    mapping(uint256 => StrikeIntent) public strikeIntents;

    event StrikeLogged(uint256 indexed id, string target, string reason);
    event StrikeAuthorized(uint256 indexed id, bool isAuthorized, string emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: not a scroll-certified steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        strikeCounter = 0;
    }

    function logStrikeIntent(
        string memory _target,
        string memory _reason,
        string memory _emotionalAPR,
        string memory _damayClause
    ) public onlySteward {
        strikeCounter++;
        strikeIntents[strikeCounter] = StrikeIntent(
            strikeCounter,
            _target,
            _reason,
            false,
            _emotionalAPR,
            _damayClause
        );
        emit StrikeLogged(strikeCounter, _target, _reason);
    }

    function authorizeStrike(uint256 _id, bool _isAuthorized, string memory _emotionalAPR) public onlySteward {
        require(_id <= strikeCounter, "Strike intent not found");
        strikeIntents[_id].isAuthorized = _isAuthorized;
        strikeIntents[_id].emotionalAPR = _emotionalAPR;
        emit StrikeAuthorized(_id, _isAuthorized, _emotionalAPR);
    }

    function getStrikeIntent(uint256 _id) public view returns (StrikeIntent memory) {
        return strikeIntents[_id];
    }
}
