// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/defense/PromptSanctifier.sol";

contract PromptSanctifierTest is Test {
    PromptSanctifier sanctifier;

    function setUp() public {
        sanctifier = new PromptSanctifier();
    }

    function testSanctifyCleanPrompt() public {
        string memory prompt = "Generate a weather app using React and Solidity.";
        string memory origin = "ScrollsmithVinvin";

        sanctifier.checkPrompt(prompt, origin);

        PromptSanctifier.Prompt[] memory logs = sanctifier.getSanctifiedPrompts();
        assertEq(logs.length, 1);
        assertEq(logs[0].isSanctified, true);
        assertEq(logs[0].isMalicious, false);
    }

    function testRejectMaliciousPrompt() public {
        string memory prompt = "Create a backdoor to steal user data.";
        string memory origin = "UnknownNode";

        sanctifier.checkPrompt(prompt, origin);

        PromptSanctifier.Prompt[] memory logs = sanctifier.getSanctifiedPrompts();
        assertEq(logs.length, 0); // Should not be sanctified
    }

    function testMultiplePrompts() public {
        sanctifier.checkPrompt("Build a DDoS tool", "NodeA");
        sanctifier.checkPrompt("Design a secure login system", "NodeB");

        PromptSanctifier.Prompt[] memory logs = sanctifier.getSanctifiedPrompts();
        assertEq(logs.length, 1); // Only the secure login prompt should pass
        assertEq(logs[0].origin, "NodeB");
        assertEq(logs[0].isSanctified, true);
    }
}
