// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.0;

import "hardhat/console.sol";

import "./datatypes/workflow/Workflow.sol";
import "./dependencies/holyzeppelin/datatypes/collections/EnumerableSet.sol";
import "./dependencies/holyzeppelin/datatypes/collections/EnumerableMap.sol";

// TODO: Consider implementation as a ERC1820 Registry
/*
 * Workflow Step Id is generated similar to interface ID from ERC165.
 * bytse4(keccak256(INTERFACE_ID)) ^ bytse4(keccak256(FUNCTION_SELECTOR))
 */
/*
 * Workflow ID is generated like ERC165 interface ID;
 * bytes4(keccak256(STEP_ID)) ^ bytes4(keccak256(STEP_ID)) . . .
 */
contract WorkflowRegistry is ERC1820EnhancedRegistry {

  using EnumerableSet for EnumerableSet.Bytes4Set;
  using EnumerableSet for EnumerableSet.AddressSet;
  using EnumerableSet for EnumerableSet.Bytes32Set;
  using Workflow for Workflow.Step;
  using Workflow for Workflow.Step;

  bytes4 immutable public WORFLOW_REGISTRY_INTERFACE_ERC165_ID;
  bytes32 immutable public WORFLOW_REGISTRY_INTERFACE_ERC1820_ID;

  IWorkflowOrchestrator private _workflowOrchestrator_;

  mapping( bytes4 => Step ) _stepForStepID_;

  mapping( bytes4 => EnumerableSet.Bytes32Set ) private _adapterERC1820IDForStepID_;

  mapping( bytes4 => Workflow ) private _workflowForWorkflowID_;

  mapping( bytes4 => EnumerableSet.Bytes4Set ) private _userApprovedWorkflows_;

  constructor () {
    console.log("Instantiating ERC1820EnhancedRegistry.");

    console.log("Calculating ERC1820_REGISTRY_INTERFACE_ERC165_ID.");
    // TODO Update with final functions
    WORFLOW_REGISTRY_INTERFACE_ERC165_ID = 
      bytes4(keccak256("setManager(address,address)"))
      ^ bytes4(keccak256("getManager(address)"))
      ^ bytes4(keccak256("setInterfaceImplementer(address,bytes32,address)"));
    console.log("Calculated ERC1820_REGISTRY_INTERFACE_ERC165_ID.");
    console.log("ERC1820_REGISTRY_INTERFACE_ERC165_ID interface ID: %s", ERC1820_REGISTRY_INTERFACE_ERC165_ID);

    console.log("Registering WorkflowRegistry ERC165 interface ID.");
    console.log("WorkflowRegistry interface ERC165 ID: %s", WORFLOW_REGISTRY_INTERFACE_ERC165_ID);
    _registerInterface( WORFLOW_REGISTRY_INTERFACE_ERC165_ID );
    console.log("Registered WorkflowRegistry ERC165 interface ID.");

    console.log("Registering ERC1820Registry ERC165 interface ID of %s for %s.", WORFLOW_REGISTRY_INTERFACE_ERC165_ID, address(this));
    _registerInterfaceForAddress( WORFLOW_REGISTRY_INTERFACE_ERC165_ID, address(this) );
    console.log("Registered ERC1820Registry ERC165 interface ID.");

    console.log("Registering WorkflowRegistry ERC165 interface ID.");
    console.log("ERC1820 interface WorkflowRegistry ID: %s", ERC1820_REGISTRY_INTERFACE_ERC165_ID);
    _registerERC165CompliantInterfaceID( address(this), ERC1820_REGISTRY_INTERFACE_ERC165_ID);
    console.log("Registered WorkflowRegistry ERC165 interface ID.");

    WORFLOW_REGISTRY_INTERFACE_ERC1820_ID = keccak256("ERC1820Registry");

    console.log("Registering WorkflowRegistry ERC1820 interface ID of %s for %s.", WORFLOW_REGISTRY_INTERFACE_ERC1820_ID, address(this));
    _registerInterfaceForAddress( WORFLOW_REGISTRY_INTERFACE_ERC1820_ID, address(this) );
    console.log("Registered WorkflowRegistry ERC1830 interface ID.");
    
    console.log("Registering WorkflowRegistry ERC1820 interface ID of %s for %s.", WORFLOW_REGISTRY_INTERFACE_ERC1820_ID, address(this));
    _registerERC1820CompliantInterfaceID( WORFLOW_REGISTRY_INTERFACE_ERC1820_ID, address(this) );
    console.log("Registered WorkflowRegistry ERC165 interface ID.");

    console.log("Instantiated ERC1820EnhancedRegistry.");
  }
  /*
   * While Workflow IDs are stored as bytes4, the ID should be a bytes4 conversion of a unit256 with the number being the order of the step.
   * i.e. the first Step should bytes4(1), the second step should be bytes4(2).
   * bytes4(0) is reserved for use as a cursor to track at what step of a workflow is a user.
   */
  function registerWorkflow( bytes4 _workflowID ) public returns (bool) {
    require( !_workflowForWorkflowID_[_workflowID]._isActive);
    _workflowForWorkflowID_[_workflowID]._isActive = true;
    return true;
  }

  function registerStep( bytes4 )

  function addStepToWorkflow( bytes4 _workflowID )

 
  
}