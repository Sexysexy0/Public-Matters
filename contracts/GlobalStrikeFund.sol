// GlobalStrikeFund.sol
pragma solidity ^0.8.0;

contract GlobalStrikeFund {
    struct Strike {
        string sector;
        uint256 dailyStipend;
        bool isActive;
    }

    mapping(uint256 => Strike) public activeStrikes;

    function supportProtesters(uint256 _strikeId) public payable {
        // Funds distributed to verified workers during state repression
        require(activeStrikes[_strikeId].isActive, "Strike not active");
        // Logic: Verified via Geolocation and Identity Oracle
    }
}
