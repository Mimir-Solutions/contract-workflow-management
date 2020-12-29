// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

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
contract WorkflowCoontroller {

  // bytes32 public WORKFLOWEXECUTOR_ERC1820_INTERFACE_ID;
  
  // TODO register it's interfaces for itself.
  // TODO needs to register itself for the user with the default registry.
  // TODO needs to register it's default registry with itself for the owner.
  constructor() {
    // WORKFLOWEXECUTOR_ERC1820_INTERFACE_ID = bytes32( keccak256( "WorkflowExecutor" ) );
  }

  /**
   * stepExecutorArguments_ shouqld be the arguments needed to execute each step. If a step requires no arguments that index should store encoded 0.
   */
  // function executeEorkflow( bytes[] calldata stepExecutorArguments_, bytes32 calldata workflowToExecute_ ) external virtual onlyOwner() {

  //   IWorkflowRegistry registry = IWorkflowRegistry( this.getInterfaceImplementer( Context._msgSender(), ERC1820_REGISTRY_INTERFACE_ID ) );

  //   IWorkflowExecutor excutor = IWorkflowRegistry( this.getInterfaceImplementer( Context._msgSender(), WORKFLOWEXECUTOR_ERC1820_INTERFACE_ID ) );

  //   bytes32[] workflow_ = registry.getWorkflow( workflowToExecute_ );

  //   require( stepExecutorArguments_.length == workflow_.length );

  //   ( bytes32[] memory stepInterfaceIDs_, bytes4[] memory stepFunctionSelectors_ ) = registry.getSteps( workflow_ );

  //   require( stepInterfaceIDs_.length == stepFunctionSelectors_.length );

  //   for( uint256 iteration_ = 0; ( stepInterfaceIDs_.length -1 ) >= iteration_; iteration_++ ) {

  //     address stepExecutor_ = this.getInterfaceImplementer( Context._msgSender(), stepInterfaceIDs_[iteration_] );

  //     excutor.executeStep( stepExecutor_, stepFunctionSelectors_[iteration_], stepExecutorArguments_[iteration_] );
  //   }
  // }
}