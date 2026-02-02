// CryptoRevivalProtocol.sol
pragma solidity ^0.8.0;

contract CryptoRevivalProtocol {
    struct Booster {
        uint256 id;
        string activity;   // e.g. "NFT Fair", "Play-to-Earn Quest"
        uint256 reward;
        uint256 timestamp;
    }

    uint256 public boosterCount;
    mapping(uint256 => Booster) public boosters;

    event BoosterIssued(uint256 id, string activity, uint256 reward, uint256 timestamp);
    event RevivalDeclared(string message);

    function issueBooster(string memory activity, uint256 reward) public {
        boosterCount++;
        boosters[boosterCount] = Booster(boosterCount, activity, reward, block.timestamp);
        emit BoosterIssued(boosterCount, activity, reward, block.timestamp);
    }

    function declareRevival() public {
        emit RevivalDeclared("Crypto Revival Protocol: ecosystem activities reignited.");
    }
}
