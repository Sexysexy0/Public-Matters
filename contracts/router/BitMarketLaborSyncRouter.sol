// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VendorBlessingProtocol.sol";
import "./APROracle.sol";

contract BitMarketLaborSyncRouter {
    address public blessingProtocol;
    address public aprOracle;

    constructor(address _blessingProtocol, address _aprOracle) {
        blessingProtocol = _blessingProtocol;
        aprOracle = _aprOracle;
    }

    function syncLaborBlessing(address steward, uint256 emotionalAPR) external {
        require(APROracle(aprOracle).validateAPR(emotionalAPR), "Invalid APR");
        VendorBlessingProtocol(blessingProtocol).blessSteward(steward, emotionalAPR);
    }
}
