// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "hardhat/console.sol";

library Workflow {

  struct Step {
    bool _isActive;
    bytes32 _interfaceID;
    bytes4 _functionSelector;
  }

  function addStep( Step step_, bool isActive_, bytes32 interfaceIDToAdd_, bytes4 functionSelectorToAdd_ ) internal returns ( bool isActive_ ) {
    step_._isActive = isActive_;
    step_._interfaceID = interfacaIDToAdd_;
    step_._functionSelector = functionSelectorToAdd_;
  }
}