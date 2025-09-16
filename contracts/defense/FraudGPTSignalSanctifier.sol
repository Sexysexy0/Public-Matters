// SPDX-License-Identifier: FraudSanctum
pragma solidity ^0.8.19;

contract FraudGPTSignalSanctifier {
    struct ExploitSignal {
        string exploitID;
        string modelAlias;
        string attackVector;
        bool contained;
        string stewardNote;
    }

    mapping(string => ExploitSignal) public exploitRegistry;

    event ExploitTagged(string exploitID, string modelAlias);
    event ExploitSanctified(string exploitID);

    function tagExploit(string memory exploitID, string memory modelAlias, string memory attackVector, string memory stewardNote) public {
        exploitRegistry[exploitID] = ExploitSignal(exploitID, modelAlias, attackVector, false, stewardNote);
        emit ExploitTagged(exploitID, modelAlias);
    }

    function sanctifyExploit(string memory exploitID) public {
        require(bytes(exploitRegistry[exploitID].modelAlias).length > 0, "Exploit not tagged");
        exploitRegistry[exploitID].contained = true;
        emit ExploitSanctified(exploitID);
    }

    function getExploitStatus(string memory exploitID) public view returns (ExploitSignal memory) {
        return exploitRegistry[exploitID];
    }
}
