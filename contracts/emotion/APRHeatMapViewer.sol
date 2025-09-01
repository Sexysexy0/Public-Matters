// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./APRHeatMap.sol";

contract APRHeatMapViewer {
    APRHeatMap public heatMap;

    constructor(address _heatMapAddress) {
        heatMap = APRHeatMap(_heatMapAddress);
    }

    struct APRView {
        string sourceTag;
        uint256 aprValue;
        string timestamp;
        string region;
        string glowTag;
    }

    function getAllSpikes() public view returns (APRView[] memory) {
        uint256 count = heatMap.getSpikeCount();
        APRView[] memory views = new APRView[](count);

        for (uint256 i = 0; i < count; i++) {
            (
                string memory sourceTag,
                uint256 aprValue,
                string memory timestamp,
                string memory region,
                string memory glowTag
            ) = heatMap.getSpikeByIndex(i);

            views[i] = APRView({
                sourceTag: sourceTag,
                aprValue: aprValue,
                timestamp: timestamp,
                region: region,
                glowTag: glowTag
            });
        }

        return views;
    }
}
