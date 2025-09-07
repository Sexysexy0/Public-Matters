// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract AlliedTariffTreaty {
    string public steward = "Vinvin Gueco";
    uint public defaultTariffRate = 25; // Represented as 2.5% (multiplied by 10 for precision)
    mapping(string => bool) public isAllied;

    event TariffSet(string country, uint rate, string clause);

    constructor() {
        // Initialize treaty allies
        isAllied["Japan"] = true;
        isAllied["USA"] = true;
        isAllied["South Korea"] = true;
        isAllied["Philippines"] = true;
        isAllied["Singapore"] = true;
        isAllied["EU"] = true;
        isAllied["Australia"] = true;
    }

    function imposeTariff(string memory country, uint rate) public returns (string memory) {
        require(rate <= defaultTariffRate, "Tariff exceeds treaty limit");
        require(isAllied[country], "Country not under treaty");

        emit TariffSet(country, rate, "Treaty clause: Allied tariff capped at 2.5%");
        return string(abi.encodePacked("Tariff of ", uint2str(rate), "‰ imposed on ", country, " — treaty compliance confirmed."));
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
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }
}
