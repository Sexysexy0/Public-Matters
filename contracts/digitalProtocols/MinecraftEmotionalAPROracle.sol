// SPDX-License-Identifier: Mythic-EmotionalOracle
pragma solidity ^0.8.19;

contract MinecraftEmotionalAPROracle {
    address public steward;

    struct APRForecast {
        string player;
        string sanctum;
        uint256 joyLevel;
        uint256 solidarityLevel;
        uint256 wonderLevel;
        uint256 forecastedAPR;
        uint256 timestamp;
    }

    APRForecast[] public forecastLog;

    event APRForecasted(
        string player,
        string sanctum,
        uint256 joyLevel,
        uint256 solidarityLevel,
        uint256 wonderLevel,
        uint256 forecastedAPR,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function forecastAPR(
        string memory player,
        string memory sanctum,
        uint256 joyLevel,
        uint256 solidarityLevel,
        uint256 wonderLevel
    ) public {
        require(msg.sender == steward, "Only steward may forecast.");

        uint256 apr = (joyLevel + solidarityLevel + wonderLevel) / 3;

        APRForecast memory f = APRForecast({
            player: player,
            sanctum: sanctum,
            joyLevel: joyLevel,
            solidarityLevel: solidarityLevel,
            wonderLevel: wonderLevel,
            forecastedAPR: apr,
            timestamp: block.timestamp
        });

        forecastLog.push(f);
        emit APRForecasted(player, sanctum, joyLevel, solidarityLevel, wonderLevel, apr, block.timestamp);
    }

    function getForecast(uint index) public view returns (APRForecast memory) {
        return forecastLog[index];
    }

    function totalForecasts() public view returns (uint) {
        return forecastLog.length;
    }
}
