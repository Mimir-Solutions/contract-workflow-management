// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

// import "../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820EnhancedRegistry.sol";
// import "../datatypes/workflow/Workflow.sol";
// import "../dependencies/holyzeppelin/contracts/datatypes/collections/EnumerableSet.sol";

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

contract StepRegistry {
  
}