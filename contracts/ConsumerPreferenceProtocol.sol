pragma solidity ^0.8.20;

contract ConsumerPreferenceProtocol {
    address public admin;

    struct Preference {
        string category;     // e.g. hybrid, BEV, PHEV
        string reason;       // e.g. affordability, convenience, transition choice
        string trend;        // e.g. rising, stable, declining
        uint256 timestamp;
    }

    Preference[] public preferences;

    event PreferenceLogged(string category, string reason, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPreference(string calldata category, string calldata reason, string calldata trend) external onlyAdmin {
        preferences.push(Preference(category, reason, trend, block.timestamp));
        emit PreferenceLogged(category, reason, trend, block.timestamp);
    }

    function totalPreferences() external view returns (uint256) {
        return preferences.length;
    }
}
