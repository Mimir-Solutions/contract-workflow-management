// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

library Workflow {

  struct Step {
    bool _isActive;
    bytes4 _interfaceID;
    bytes4 _functionSelector;
    
  }

  struct Workflow {
    mapping( bytes4 => Step ) _workflow;
  }
}