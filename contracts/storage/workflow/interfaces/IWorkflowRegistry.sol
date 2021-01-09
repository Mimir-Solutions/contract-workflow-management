// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

import "hardhat/console.sol";

// TODO: Consider implementation as a ERC1820 Registry

/*
 * Step consists of itnterface and function selector.
 * Step ID can be calculated from function signature with the following conversion.
 * byes32( bytes32( keccak256( <InterfaceID> ) ) ^ bytes32( bytes4( keccak256( bytes( <Function Signature> ) ) ) ) )
 * Step ID can be calculated from function selector with the following conversion.
 * byes32( bytes32( keccak256( <InterfaceID> ) ^ bytes32( <Function Selector> ) )
 */

/*
 * Step Executor consists of an address and a function selector.
 * Step Executor ID can be calculated from function signature with the following conversion.
 * byes32( bytes32( address ) ^ bytes32( bytes4( keccak256( bytes( <Function Signature> ) ) ) ) )
 * Step ID can be calculated from function selector with the following conversion.
 * byes32( bytes32( address ) ^ bytes32( <Function Selector> ) )
 */

/*
 * Workflow consists of an array of Steps in the order to execute.
 * Workflow can aslo consist of an array of function selectors in the order to execute.
 * Workflow ID can be calculated using the following conversion.
 * bytes4( <Function Selector> ^ <Function Selector> . . . )
 */

/*
 * Job consists of an array of function selectors in the order to execute and an array of addresses on which to execute.
 * Job ID can be calculated using the following conversion.
 * byes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) )
 */

interface IWorkflowRegistry {

  /*
   * TODO Update to Natspec comment
   * Exposes internal function that provides consistent encoding of job IDs to minimize gas feee when used internally.
   */
  function encodeWorkflowID( bytes4[] memory stepExecutorFunctionSelectors_ ) external pure returns ( bytes4 );

  /*
   * TODO Update to Natspec comment
   * Exposes internal function that provided consistent encoding of function selectors.
   */
  function encodeFunctionSelector( string calldata functionSignatureToEncode_ ) external pure returns ( bytes4 );

  function encodeFunctionSelectors( string[] memory functionSignaturesToEncode_ ) external pure returns ( bytes4[] memory );

  function registerWorkflow( bytes4[] memory stepExecutorFunctionSelectorsToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) external returns ( bytes4 );

  function registerWorkflow( string[] memory stepExecutorFunctionSelectorsToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) external returns ( bytes4 );

  function  getWorkflowForWorkflowID( bytes4 workflowID_ ) external view returns ( bytes4[] memory, address[] memory );

  function insertStepExecutorInWorkflow( bytes4 workflowID_, address stepExecutorAddressesToInsert_, uint256 index_ ) external returns ( bool );
}