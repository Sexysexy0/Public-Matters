pragma solidity ^0.8.0;

contract CustomEngineFund {
    mapping(address => uint256) public grants;

    function supportStudio(address studio, bool proprietary) public {
        if (proprietary) {
            grants[studio] += 1000000; // Fund allocation for custom engine R&D
        }
    }
}
