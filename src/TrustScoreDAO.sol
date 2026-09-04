// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract TrustScoreDAO {
    address public admin;
    mapping(address => uint256) public trustScore;

    event TrustScoreUpdated(address indexed user, uint256 newScore);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function setTrustScore(address _user, uint256 _score) public onlyAdmin {
        trustScore[_user] = _score;
        emit TrustScoreUpdated(_user, _score);
    }

    function getTrustScore(address _user) public view returns (uint256) {
        return trustScore[_user];
    }

    function increaseScore(address _user, uint256 _amount) public onlyAdmin {
        trustScore[_user] += _amount;
        emit TrustScoreUpdated(_user, trustScore[_user]);
    }

    function decreaseScore(address _user, uint256 _amount) public onlyAdmin {
        require(trustScore[_user] >= _amount, "Score too low");
        trustScore[_user] -= _amount;
        emit TrustScoreUpdated(_user, trustScore[_user]);
    }
}
