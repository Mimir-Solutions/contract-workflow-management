// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

import "hardhat/console.sol";

// import "../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820EnhancedRegistry.sol";
// import "../datatypes/workflow/Workflow.sol";
// import "../dependencies/holyzeppelin/contracts/datatypes/collections/EnumerableSet.sol";

// TODO: Consider implementation as a ERC1820 Registry

/*
 * Initial implementation optimizes Jobs to simply an array of function selectors and an array of address on which to execute in the eorder of execution.
 * The intention is to enable future extension with a more granular defintion of a Job.
 * Job ID can be calculated using the following conversion.
 * bytes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) . . . )
 */

/************************************** NOTED FOR POSSIBLE FUTURE IMPLEMENTATION **************************************/
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
/************************************** NOTED FOR POSSIBLE FUTURE IMPLEMENTATION **************************************/

interface IJobRegistry {

  /*
   * TODO Update to Natspec comment
   * Exposes internal function that provided consistent encoding of job IDs.
   */
  function encodeJobID( address[] calldata stepExecutorAddresses_, bytes4[] calldata stepExecutorFunctionSelectors_ ) external pure returns ( bytes32 );
  
  function encodeFunctionSelector( string calldata functionSignatureToEncode_ ) external pure returns ( bytes4 );

  function encodeFunctionSelectors( string[] calldata functionSignaturesToEncode_ ) external pure returns ( bytes4[] memory );

  function registerJob( bytes32 jobIDToRegister_, address[] calldata stepExecutorAddressesToRegister_, bytes4[] calldata stepExecutorFunctionSelectorsToRegister_ ) external;

  function registerJob( address[] calldata stepExecutorAddressesToRegister_, bytes4[] calldata stepExecutorFunctionSelectorsToRegister_ ) external;

  function registerJob( address[] calldata stepExecutorAddressesToRegister_, string[] calldata stepExecutorFunctionSelectorsToRegister_ ) external;

  function getJobForJobID( bytes32 jobID_ ) external view returns ( address[] calldata, bytes4[] calldata );

}