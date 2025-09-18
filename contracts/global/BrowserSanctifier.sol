// SPDX-License-Identifier: BrowserSanctifier
pragma solidity ^0.8.19;

contract BrowserSanctifier {
    address public steward;

    struct ExploitSignal {
        string browserName; // e.g. "Chrome", "Edge", "Brave"
        string exploitCode; // e.g. "CVE-2025-10585"
        string patchVersion; // e.g. "140.0.7339.185"
        bool verified;
        uint256 timestamp;
    }

    ExploitSignal[] public signals;

    event ExploitLogged(string browserName, string exploitCode, string patchVersion, uint256 timestamp);
    event ExploitVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logExploit(
        string memory browserName,
        string memory exploitCode,
        string memory patchVersion
    ) public {
        signals.push(ExploitSignal(browserName, exploitCode, patchVersion, false, block.timestamp));
        emit ExploitLogged(browserName, exploitCode, patchVersion, block.timestamp);
    }

    function verifyExploit(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ExploitVerified(index, msg.sender);
    }

    function totalExploitSignals() public view returns (uint256) {
        return signals.length;
    }
}
