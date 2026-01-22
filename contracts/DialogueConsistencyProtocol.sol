pragma solidity ^0.8.20;

contract DialogueConsistencyProtocol {
    address public admin;

    struct Dialogue {
        string passage;      // e.g. Gospel scene
        string trait;        // e.g. consistent high-effort reasoning
        string effect;       // e.g. immersion, credibility
        uint256 timestamp;
    }

    Dialogue[] public dialogues;

    event DialogueLogged(string passage, string trait, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDialogue(string calldata passage, string calldata trait, string calldata effect) external onlyAdmin {
        dialogues.push(Dialogue(passage, trait, effect, block.timestamp));
        emit DialogueLogged(passage, trait, effect, block.timestamp);
    }

    function totalDialogues() external view returns (uint256) {
        return dialogues.length;
    }
}
