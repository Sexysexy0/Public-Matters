// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BanterSovereigntyClause {
    mapping(address => bool) public sovereignSpeakers;
    mapping(address => string) public fallbackStatus;

    event ExpressionLogged(address indexed speaker, string contentHash);
    event FallbackActivated(address indexed speaker, string reason);
    event ArbitrationRequested(address indexed speaker);

    function logExpression(address _speaker, string memory _contentHash) public {
        sovereignSpeakers[_speaker] = true;
        emit ExpressionLogged(_speaker, _contentHash);
    }

    function activateFallback(address _speaker, string memory _reason) public {
        fallbackStatus[_speaker] = _reason;
        emit FallbackActivated(_speaker, _reason);
    }

    function requestArbitration(address _speaker) public {
        require(keccak256(bytes(fallbackStatus[_speaker])) != keccak256(bytes("")), "No fallback triggered");
        emit ArbitrationRequested(_speaker);
    }
}
