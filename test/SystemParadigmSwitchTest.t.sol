// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SystemParadigmSwitch.sol";

contract SystemParadigmSwitchTest is Test {
    SystemParadigmSwitch switcher;

    function setUp() public {
        switcher = new SystemParadigmSwitch();
    }

    function testSwitchParadigm() public {
        vm.roll(block.number + 20000);
        switcher.switchParadigm(SystemParadigmSwitch.Paradigm.Emergent);
        assertEq(uint(switcher.current()), uint(SystemParadigmSwitch.Paradigm.Emergent));
    }
}
