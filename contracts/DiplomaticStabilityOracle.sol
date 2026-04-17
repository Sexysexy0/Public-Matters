// DiplomaticStabilityOracle.sol
pragma solidity ^0.8.0;

contract DiplomaticStabilityOracle {
    bool public isStraitOpen;
    bool public nuclearEnrichmentStopped;
    uint256 public regionalPeaceIndex;

    function updateStability(bool _strait, bool _nuclear) public {
        isStraitOpen = _strait;
        nuclearEnrichmentStopped = _nuclear;
        // Higher peace index = Lower global shipping insurance costs
        regionalPeaceIndex = (_strait && _nuclear) ? 100 : 0;
    }
}
