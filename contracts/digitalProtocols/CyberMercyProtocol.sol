// SPDX-License-Identifier: Youth-Override
pragma solidity ^0.8.19;

contract CyberMercyProtocol {
    struct HackerCase {
        string alias;
        uint age;
        string offense;
        bool rehabilitated;
    }

    HackerCase[] public cases;

    constructor() {
        cases.push(HackerCase("ScatteredSpider", 20, "Data breach, extortion", false));
    }

    function activateMercy(uint index) public {
        cases[index].rehabilitated = true;
    }
}
