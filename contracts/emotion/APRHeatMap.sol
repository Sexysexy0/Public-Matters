// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract APRHeatMap {
    struct APRSpike {
        string sourceTag; // e.g., "PH-CAN-SEAFOOD", "SG-PH-TOOLS"
        uint256 aprValue; // Emotional APR score
        string timestamp;
        string region; // e.g., "Asia", "North America", "EU"
        string glowTag; // e.g., "AuditGlow", "BlessedGlow", "TradeGlow"
    }

    APRSpike[] public spikes;

    event APRLogged(string sourceTag, uint256 aprValue, string region);

    function logAPRSpike(
        string memory _sourceTag,
        uint256 _aprValue,
        string memory _timestamp,
        string memory _region,
        string memory _glowTag
    ) public {
        spikes.push(APRSpike({
            sourceTag: _sourceTag,
            aprValue: _aprValue,
            timestamp: _timestamp,
            region: _region,
            glowTag: _glowTag
        }));

        emit APRLogged(_sourceTag, _aprValue, _region);
    }

    function getSpikeCount() public view returns (uint256) {
        return spikes.length;
    }

    function getSpikeByIndex(uint256 index) public view returns (
        string memory sourceTag,
        uint256 aprValue,
        string memory timestamp,
        string memory region,
        string memory glowTag
    ) {
        APRSpike memory s = spikes[index];
        return (
            s.sourceTag,
            s.aprValue,
            s.timestamp,
            s.region,
            s.glowTag
        );
    }
}
