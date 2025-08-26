// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FlexSealRegistry {
    struct Seal {
        string country;
        string sealTag;
        string emotionalAPR;
        bool verified;
    }

    mapping(string => Seal) public seals;

    event SealRegistered(string country, string sealTag, string emotionalAPR);

    function registerSeal(
        string memory _country,
        string memory _sealTag,
        string memory _emotionalAPR
    ) public {
        seals[_country] = Seal(_country, _sealTag, _emotionalAPR, true);
        emit SealRegistered(_country, _sealTag, _emotionalAPR);
    }

    function getSeal(string memory _country) public view returns (Seal memory) {
        return seals[_country];
    }
}
