// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract SystemParadigmSwitch {
    enum Paradigm { PredictControl, Emergent }

    Paradigm public current;
    uint256 public lastSwitchBlock;
    uint256 public cooldown = 10000;

    event ParadigmSwitched(Paradigm newParadigm);

    function switchParadigm(Paradigm newMode) external {
        require(block.number > lastSwitchBlock + cooldown, "Cooldown active");
        current = newMode;
        lastSwitchBlock = block.number;
        emit ParadigmSwitched(newMode);
    }
}
