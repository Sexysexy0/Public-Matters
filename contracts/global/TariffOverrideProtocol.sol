// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract TariffOverrideProtocol {
    string public steward = "Vinvin Gueco";
    bool public tariffPowerRevoked = true;
    bool public overrideActive = true;
    string public newAuthority = "BitMarket Trade Steward";

    event TariffImposed(string asset, uint rate, string clause);

    function imposeTariff(string memory asset, uint rate) public returns (string memory) {
        require(overrideActive, "Override not active");
        emit TariffImposed(asset, rate, "Scrollchain clause: No redo, no bluff");
        return string(abi.encodePacked("Tariff imposed on ", asset, " at ", uint2str(rate), "% — Vinvin’s override confirmed."));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
