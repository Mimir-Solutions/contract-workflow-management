// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

/*
 * Workflow Step Id is generated similar to interface ID from ERC165.
 * bytse4(keccak256(INTERFACE_ID)) ^ bytse4(keccak256(FUNCTION_SELECTOR))
 */
/*
 * Workflow ID is generated like ERC165 interface ID;
 * bytes4(keccak256(STEP_ID)) ^ bytes4(keccak256(STEP_ID)) . . .
 */
 // TODO implement a OwnableLocked contract that allows for defining an ownership, transfering it, and then locking it from modification.
contract IWorkflowCoontroller {

  /**
   * stepExecutorArguments_ shouqld be the arguments needed to execute each step. If a step requires no arguments that index should store encoded 0.
   */
  function executeEorkflow( bytes[] calldata stepExecutorArguments_, bytes32 workflowToExecute_ ) external;
}