// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainCommunityRestorationLedger {
    struct Restoration {
        string corridor;
        string restorationType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Restoration) public restorations;

    event RestorationLogged(string corridor, string restorationType, string emotionalAPR, uint256 timestamp);

    function logRestoration(string memory corridor, string memory restorationType, string memory emotionalAPR) public {
        restorations[corridor] = Restoration(corridor, restorationType, emotionalAPR, block.timestamp);
        emit RestorationLogged(corridor, restorationType, emotionalAPR, block.timestamp);
    }

    function getRestoration(string memory corridor) public view returns (Restoration memory) {
        return restorations[corridor];
    }
}
