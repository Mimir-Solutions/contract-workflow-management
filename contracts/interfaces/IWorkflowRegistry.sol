// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

import "hardhat/console.sol";

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

  function registerStepID( string calldata erc1820InterfaceIDToEncode_, string calldata functionSignature_ ) external;

  /**
   * Returns 2 arrays of the interface ID and function selectors in the same order as provided.
   */
  function getStep( bytes32 stepID_ ) external view returns ( bytes32 stepInterfaceID_, bytes4 stepFunctionSelector_ );

  function getSteps( bytes32[] calldata stepIDs_ ) external view returns ( bytes32[] calldata stepInterfaceIDs_, bytes4[] calldata stepFunctionSelectors_ );

  function getAllSteps() external view returns ( bytes32[] calldata stepIDs_ );

  function registerStepExecutor( address stepExecutorAddress_, string calldata stepExecutor1820InterfaceID_, string calldata stepExecutorFunctionSelector_ ) external;

  function deregisterStepExecutor( address stepExecutorAddress_, bytes32 stepExecutor1820InterfaceID_ ) external;

  function getStepExecutor( bytes32 stepID_ ) external view returns ( address stepExecutorAddress_ );

  function registerWorkflow( bytes32 workflowID_, bytes32[] calldata stepIDs_ ) external;

  function registerWorkflow( string[] calldata workflowERC1820InterfaaceIDs_, string[] calldata workflowFunctionSelectors_ ) external;

  function getWorkflow( bytes32 workflowID_ ) view external returns ( bytes32[] calldata workflow_ );

  function setDefaultStepExecutor( address stepExecutorAddress_, string calldata stepExecutor1820InterfaceID_ ) external;
}