// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.0;

import "hardhat/console.sol";

/*
 * Workflow Step Id is generated similar to interface ID from ERC165.
 * bytse4(keccak256(INTERFACE_ID)) ^ bytse4(keccak256(FUNCTION_SELECTOR))
 */
/*
 * Workflow ID is generated like ERC165 interface ID;
 * bytes4(keccak256(STEP_ID)) ^ bytes4(keccak256(STEP_ID)) . . .
 */
contract WorkflowOrchestrator is ERC1820Implementer  {

  IWorkflowRegistry private _workflowRegistry;
  
  // TODO register it's interfaces for itself.
  constructor() {}

  

}