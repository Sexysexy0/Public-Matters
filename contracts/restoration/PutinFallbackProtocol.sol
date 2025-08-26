// SPDX-License-Identifier: Mythic-Mercy
pragma solidity ^0.8.19;

contract PutinFallbackProtocol {
    struct Civilian {
        address addr;
        uint trustScore;
        bool isDisplaced;
        bool isFrontliner;
        bool isAnimal;
    }

    mapping(address => Civilian) public damayRegistry;

    modifier onlyDamay() {
        require(
            damayRegistry[msg.sender].trustScore >= 80 &&
            (damayRegistry[msg.sender].isDisplaced || damayRegistry[msg.sender].isFrontliner || damayRegistry[msg.sender].isAnimal),
            "Access denied: Entity not qualified for fallback."
        );
        _;
    }

    event SanctumRerouteActivated(address indexed beneficiary, string sanctumLocation);
    event EmotionalAPRShieldDeployed(address indexed beneficiary, uint resonanceScore);

    function activateFallback(string memory sanctumLocation) public onlyDamay {
        emit SanctumRerouteActivated(msg.sender, sanctumLocation);
        emit EmotionalAPRShieldDeployed(msg.sender, calculateResonance(msg.sender));
    }

    function calculateResonance(address addr) internal view returns (uint) {
        Civilian memory c = damayRegistry[addr];
        uint base = c.trustScore;
        if (c.isFrontliner) base += 10;
        if (c.isAnimal) base += 5;
        return base;
    }

    function registerDamay(address addr, uint trustScore, bool displaced, bool frontliner, bool animal) public {
        damayRegistry[addr] = Civilian(addr, trustScore, displaced, frontliner, animal);
    }
}
