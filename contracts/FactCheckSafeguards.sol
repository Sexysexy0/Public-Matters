// FactCheckSafeguards.sol
pragma solidity ^0.8.0;

contract FactCheckSafeguards {
    struct NewsArticle {
        bytes32 contentHash;
        uint256 verificationCount;
        bool isVerified;
        mapping(address => bool) validators;
    }

    mapping(bytes32 => NewsArticle) public newsRegistry;

    function submitVerification(bytes32 _hash) public {
        // Only authorized fact-checkers can call this
        require(!newsRegistry[_hash].validators[msg.sender], "Already verified by you");
        
        newsRegistry[_hash].validators[msg.sender] = true;
        newsRegistry[_hash].verificationCount++;
        
        if (newsRegistry[_hash].verificationCount >= 3) {
            newsRegistry[_hash].isVerified = true;
        }
    }
}
