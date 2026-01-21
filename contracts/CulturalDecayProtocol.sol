pragma solidity ^0.8.20;

contract CulturalDecayProtocol {
    address public admin;

    struct Decay {
        string domain;       // e.g. media, education, entertainment
        string symptom;      // e.g. explicit content, occult glorification, moral erosion
        uint256 timestamp;
    }

    Decay[] public decays;

    event DecayLogged(string domain, string symptom, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDecay(string calldata domain, string calldata symptom) external onlyAdmin {
        decays.push(Decay(domain, symptom, block.timestamp));
        emit DecayLogged(domain, symptom, block.timestamp);
    }

    function totalDecays() external view returns (uint256) {
        return decays.length;
    }
}
