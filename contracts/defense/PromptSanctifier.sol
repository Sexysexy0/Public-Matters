// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PromptSanctifier {
    struct Prompt {
        string content;
        string origin;
        bool isMalicious;
        bool isSanctified;
        uint256 timestamp;
    }

    Prompt[] public prompts;

    event PromptChecked(
        string content,
        string origin,
        bool isMalicious,
        bool isSanctified,
        uint256 timestamp
    );

    function checkPrompt(string memory _content, string memory _origin) public {
        bool malicious = detectMalice(_content);
        bool sanctified = !malicious;
        uint256 time = block.timestamp;

        prompts.push(Prompt(_content, _origin, malicious, sanctified, time));
        emit PromptChecked(_content, _origin, malicious, sanctified, time);
    }

    function detectMalice(string memory _content) internal pure returns (bool) {
        bytes memory b = bytes(_content);

        // Basic pattern detection (expandable)
        if (
            contains(b, "malware") ||
            contains(b, "exploit") ||
            contains(b, "bypass firewall") ||
            contains(b, "inject") ||
            contains(b, "ddos") ||
            contains(b, "steal") ||
            contains(b, "backdoor") ||
            contains(b, "ransomware") ||
            contains(b, "spyware")
        ) {
            return true;
        }
        return false;
    }

    function contains(bytes memory haystack, string memory needle) internal pure returns (bool) {
        bytes memory bneedle = bytes(needle);
        if (bneedle.length > haystack.length) return false;

        for (uint256 i = 0; i <= haystack.length - bneedle.length; i++) {
            bool match = true;
            for (uint256 j = 0; j < bneedle.length; j++) {
                if (haystack[i + j] != bneedle[j]) {
                    match = false;
                    break;
                }
            }
            if (match) return true;
        }
        return false;
    }

    function getSanctifiedPrompts() public view returns (Prompt[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < prompts.length; i++) {
            if (prompts[i].isSanctified) count++;
        }

        Prompt[] memory sanctified = new Prompt[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < prompts.length; i++) {
            if (prompts[i].isSanctified) {
                sanctified[index] = prompts[i];
                index++;
            }
        }

        return sanctified;
    }
}
