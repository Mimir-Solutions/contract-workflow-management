// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

import "../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820EnhancedRegistry.sol";
import "../datatypes/workflow/Workflow.sol";
import "../dependencies/holyzeppelin/contracts/datatypes/primitives/Address.sol";
import "../dependencies/holyzeppelin/contracts/datatypes/collections/EnumerableSet.sol";

// TODO: Consider implementation as a ERC1820 Registry
/*
 * Workflow Step Id is generated similar to interface ID from ERC165.
 * bytse4(keccak256(INTERFACE_ID)) ^ bytse4(keccak256(FUNCTION_SELECTOR))
 */
/*
 * Workflow ID is generated like ERC165 interface ID;
 * bytes4(keccak256(STEP_ID)) ^ bytes4(keccak256(STEP_ID)) . . .
 */
interface IWorkflowRegistry {

  using Workflow for Workflow.Step;
  using EnumerableSet for EnumerableSet.AddressSet;
  using Address for address;

  function registerStepID( string memory erc1820InterfaceIDToEncode_, string memory functionSignature_ ) internal;

  /**
   * Returns 2 arrays of the interface ID and function selectors in the same order as provided.
   */
  function getStep( bytes32 stepID_ ) external view returns ( bytes32 memory stepInterfaceID_, bytes4 stepFunctionSelector_ );

  function getSteps( bytes32[] stepIDs_ ) internal view returns ( bytes32[] memory stepInterfaceIDs_, bytes4[] memory stepFunctionSelectors_ );

  function getAllSteps() external view returns ( bytes32[] stepIDs_ );

  function registerStepExecutor( address stepExecutorAddress_, string stepExecutor1820InterfaceID_, string stepExecutorFunctionSelector_ ) external;

  function deregisterStepExecutor( address stepExecutorAddress_, bytes32 stepExecutor1820InterfaceID_ ) external;

  function getStepExecutor( bytes32 stepID_ ) internal view returns ( address stepExecutorAddress_ );

  function registerWorkflow( bytes32 workflowID_, bytes32[] stepIDs_ ) external;

  function registerWorkflow( string[] workflowERC1820InterfaaceIDs_, string[] workflowFunctionSelectors_ ) public;

  function getWorkflow( bytes32 workflowID_ ) external view returns ( bytes32[] workflow_ );

  function setDefaultStepExecutor( address stepExecutorAddress_, string stepExecutor1820InterfaceID_ ) external;
}