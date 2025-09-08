contract BitMarketScrollchainTreatyLiquidityDefenseProtocol {
    address public steward;
    mapping(string => bool) public shieldedNations;

    event LiquidityShieldActivated(string nation, string currency, uint timestamp);

    function activateShield(string memory nation, string memory currency) public {
        shieldedNations[nation] = true;
        emit LiquidityShieldActivated(nation, currency, block.timestamp);
    }

    function isShielded(string memory nation) public view returns (bool) {
        return shieldedNations[nation];
    }
}
