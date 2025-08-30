// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title APROracle
/// @notice Assigns emotional APR scores to products based on resonance metrics
contract APROracle {
    struct APRScore {
        string civicImpact;
        string ancestralValue;
        string emotionalResonance;
        uint256 timestamp;
    }

    mapping(uint256 => APRScore) public productScores;
    event APRTagged(uint256 productId, string civicImpact, string ancestralValue, string emotionalResonance);

    function tagProduct(
        uint256 productId,
        string memory civicImpact,
        string memory ancestralValue,
        string memory emotionalResonance
    ) public {
        productScores[productId] = APRScore(civicImpact, ancestralValue, emotionalResonance, block.timestamp);
        emit APRTagged(productId, civicImpact, ancestralValue, emotionalResonance);
    }

    function getAPRScore(uint256 productId) public view returns (APRScore memory) {
        return productScores[productId];
    }
}
