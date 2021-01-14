// // SPDX-License-Identifier: AGPL-3.0-or-later
// pragma solidity 0.7.5;
// pragma abicoder v2;

// import "hardhat/console.sol";

// import "../../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820Registrar.sol";
// import "../../dependencies/holyzeppelin/contracts/datatypes/ipfs/IPFSHash.sol";
// import "./interfaces/IWorkflowRegistry.sol";

// // TODO: Consider implementation as a ERC1820 Registry

// /*
//  * Step consists of itnterface and function selector.
//  * Step ID can be calculated from function signature with the following conversion.
//  * byes32( bytes32( keccak256( <InterfaceID> ) ) ^ bytes32( bytes4( keccak256( bytes( <Function Signature> ) ) ) ) )
//  * Step ID can be calculated from function selector with the following conversion.
//  * byes32( bytes32( keccak256( <InterfaceID> ) ^ bytes32( <Function Selector> ) )
//  */

// /*
//  * Step Executor consists of an address and a function selector.
//  * Step Executor ID can be calculated from function signature with the following conversion.
//  * byes32( bytes32( address ) ^ bytes32( bytes4( keccak256( bytes( <Function Signature> ) ) ) ) )
//  * Step ID can be calculated from function selector with the following conversion.
//  * byes32( bytes32( address ) ^ bytes32( <Function Selector> ) )
//  */

// /*
//  * Workflow consists of an array of Steps in the order to execute.
//  * Workflow can aslo consist of an array of function selectors in the order to execute.
//  * Workflow ID can be calculated using the following conversion.
//  * bytes4( <Function Selector> ^ <Function Selector> . . . )
//  */

// /*
//  * Job consists of an array of function selectors in the order to execute and an array of addresses on which to execute.
//  * Job ID can be calculated using the following conversion.
//  * byes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) )
//  */

// contract WorkflowRegistry is IWorkflowRegistry, ERC1820Registrar {

//   using IPFSHash for IPFSHash.MultiHash;

//   // TODO replace with calculated value.
//   // TODO update with final functions.
//   bytes4 constant public WORKFLOW_REGISTRY_INTERFACE_ERC165_ID = 
//       bytes4(keccak256("encodeJobID(address[],bytes4[])"))
//       ^ bytes4(keccak256("encodeFunctionSelector(string)"))
//       ^ bytes4(keccak256("encodeFunctionSelectors(string[])"))
//       ^ bytes4(keccak256("registerWorkflow(address[],bytes4[])"))
//       ^ bytes4(keccak256("registerWorkflow(address[],string[])"));

//   bytes32 constant public WORKFLOW_REGISTRY_INTERFACE_ERC1820_ID = keccak256( "WorkflowRegistry" );

//   // bytes4 public constant INVALID_FUNCTION_SELECTOR = bytes4( keccak256( bytes(0) ) );
//   // bytes32 public constant INVALID_ERC1820_INTERFACE_ID = bytes32( keccak256( bytes(0) ) );
//   // bytes32 public constant INVALID_STEP_ID = bytes4( keccak256( bytes(0) ) );

//   /*
//    * WorkflowID is bytes4( FUNCTION_SELECTOR ^ FUNCTION_SELECTOR ) . . .
//    *  Repeat function selectors for each step
//    */
//   mapping( bytes4 => bytes4[] ) private workflowIDForSteps;
//   mapping( bytes4 => address[] ) private workflowIDForStepExecutors;
//   mapping( bytes4 => string ) private workflowIDForWorkflowName;
//   mapping( bytes4 => IPFSHash.MultiHash ) private workflowIDForWorkflowContentHash;

//   constructor(
//   ) 
//     ERC1820Registrar(
//     ) 
//   {
//     console.log("Instantiating WorkflowRegistry.");

//     console.log("Registering WorkflowRegistry ERC165 interface ID with self.");
//     console.log("WorkflowRegistry interface ERC165 ID: %s", address( uint256( bytes32( WORKFLOW_REGISTRY_INTERFACE_ERC165_ID ) ) ) );
//     _addERC165InterfaceIDToSelf( WORKFLOW_REGISTRY_INTERFACE_ERC165_ID );
//     console.log("Registered WorkflowRegistry ERC165 interface ID with self.");

//     console.log("Registering WorkflowRegistry ERC1820 interface ID of %s for %s with self.", address( uint256( WORKFLOW_REGISTRY_INTERFACE_ERC1820_ID) ), address(this));
//     _addERC1820InterfaceIDToSelf( WORKFLOW_REGISTRY_INTERFACE_ERC1820_ID );
//     console.log("Registered WorkflowRegistry ERC1830 interface ID with self.");

//     console.log( "Registering interfaces wiht self." );
//     _registerInterfacesWithSelf();
//     console.log( "Registered interfaces wiht self." );

//     console.log( "ERC1820Registrar::constructor:7 Saving registry manager of %s.",  registryManager_);
//     _setRegistryManager( msg.sender );
//     console.log( "ERC1820Registrar::constructor:8 Saved registry manager of %s.", registryManager_ );
    
//     console.log( "Registering interfaces wiht external registries." );
//     _registerWithRegisties();
//     console.log( "Registered interfaces wiht external registries." );

//     console.log("Instantiated WorkflowRegistry.");
//   }

//   /*
//    * TODO Update to Natspec comment
//    * Intended to provide consistent encoding of Job IDs.
//    */
//   function _encodeWorkflowID( bytes4[] memory stepExecutorFunctionSelectors_ ) internal pure returns ( bytes4 ) {
//     require( stepExecutorFunctionSelectors_.length > 0, "There must be a step executor to register." );

//     bytes4 workflowID_;
//     for( uint256 iteration_ = 0; stepExecutorFunctionSelectors_.length > iteration_; iteration_ ) {
//       workflowID_ = workflowID_ ^ stepExecutorFunctionSelectors_[iteration_];
//     }

//     return workflowID_;
//   }

//   /*
//    * TODO Update to Natspec comment
//    * Exposes internal function that provides consistent encoding of job IDs to minimize gas feee when used internally.
//    */
//   function encodeWorkflowID( bytes4[] memory stepExecutorFunctionSelectors_ ) external pure override returns ( bytes4 ) {
//     return _encodeWorkflowID( stepExecutorFunctionSelectors_ );
//   }

//   /*
//    * TODO Update to Natspec comment
//    * Intended to provide consistent encoding of function selectors.
//    */
//   function _encodeFunctionSelector( string memory functionSignatureToEncode_ ) internal pure returns ( bytes4 ) {
//     return bytes4( keccak256( bytes( functionSignatureToEncode_ ) ) );
//   }

//   /*
//    * TODO Update to Natspec comment
//    * Exposes internal function that provided consistent encoding of function selectors.
//    */
//   function encodeFunctionSelector( string calldata functionSignatureToEncode_ ) external pure override returns ( bytes4 ) {
//     return _encodeFunctionSelector( functionSignatureToEncode_ );
//   }

//   function _encodeFunctionSelectors( string[] memory functionSignaturesToEncode_ ) internal pure returns ( bytes4[] memory ) {
//     bytes4[] memory encodedFunctionSelectors_;
//     for( uint256 iteration_ = 0; functionSignaturesToEncode_.length > iteration_; iteration_++ ) {
//       encodedFunctionSelectors_[iteration_] = _encodeFunctionSelector( functionSignaturesToEncode_[iteration_] );
//     }

//     return encodedFunctionSelectors_;
//   }

//   function encodeFunctionSelectors( string[] memory functionSignaturesToEncode_ ) external pure override returns ( bytes4[] memory ) {
//     return _encodeFunctionSelectors( functionSignaturesToEncode_ );
//   }

//   function _saveWorkflowContentHash( bytes4 workflowID_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) internal returns ( bool ) {
//     return workflowIDForWorkflowContentHash[workflowID_].add( hashFunction_, size_, contentGash_ );
//   }

//   function _registerWorkflow( bytes4[] memory stepExecutorFunctionSelectorsToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) internal returns ( bytes4 ) {
//     require( stepExecutorFunctionSelectorsToRegister_.length > 0, "Must have steps to register workflow." );
//     require( stepExecutorAddressesToRegister_.length > 0, "Must have step executor addresses to register workflow." );
//     require( stepExecutorFunctionSelectorsToRegister_.length  == stepExecutorAddressesToRegister_.length, "Must have a step executor address for every step." );
//     require( contentGash_ > bytes32(0) && hashFunction_ > 0 && size_ > 0, "Workflow must have documentation to register." );
//     bytes4 workflowID_ = _encodeWorkflowID( stepExecutorFunctionSelectorsToRegister_ );

//     workflowIDForSteps[workflowID_] = stepExecutorFunctionSelectorsToRegister_;

//     workflowIDForStepExecutors[workflowID_] = stepExecutorAddressesToRegister_;

//     require( _saveWorkflowContentHash( workflowID_, contentGash_, hashFunction_, size_ ), "Could not save workflow IPFS content hash." );

//     return workflowID_;
//   }

//   function registerWorkflow( bytes4[] memory stepExecutorFunctionSelectorsToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) external override onlyManager() returns ( bytes4 ) {
//     return _registerWorkflow( stepExecutorFunctionSelectorsToRegister_, stepExecutorAddressesToRegister_, contentGash_, hashFunction_, size_ );
//   }

//   function registerWorkflow( string[] memory stepExecutorFunctionSelectorsToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes32 contentGash_, uint8 hashFunction_, uint8 size_ ) external override onlyManager() returns ( bytes4 ) {
//     bytes4[] memory encodedFunctionSelectors_ =  _encodeFunctionSelectors( stepExecutorFunctionSelectorsToRegister_ );
//     return _registerWorkflow( encodedFunctionSelectors_, stepExecutorAddressesToRegister_, contentGash_, hashFunction_, size_ );
//   }

//   function _getWorkflowForWorkflowID( bytes4 workflowID_ ) internal view returns ( bytes4[] memory, address[] memory ) {
//     return ( workflowIDForSteps[workflowID_], workflowIDForStepExecutors[workflowID_] );
//   }

//   function  getWorkflowForWorkflowID( bytes4 workflowID_ ) external view override returns ( bytes4[] memory, address[] memory ) {
//     return _getWorkflowForWorkflowID( workflowID_ );
//   }

//   function _recurseStepExecutorInsert( bytes4 workflowID_, address stepExecutorAddressesToInsert_, uint256 index_ ) internal returns ( address ) {
//     address existingStepExecutor_ = workflowIDForStepExecutors[workflowID_][index_];
//     workflowIDForStepExecutors[workflowID_][index_] = stepExecutorAddressesToInsert_;

//     return existingStepExecutor_;
//   }

//   function _insertStepExecutorInWorkflow( bytes4 workflowID_, address stepExecutorAddressesToInsert_, uint256 index_ ) internal returns ( bool ) {
//     require( workflowIDForStepExecutors[workflowID_].length > index_, "You cannot extend the length of step executors." );
//     address existingStepExecutor_ = stepExecutorAddressesToInsert_;
//     for( uint256 iteration_ = index_; workflowIDForStepExecutors[workflowID_].length > index_; iteration_++ ) {
//       existingStepExecutor_ =  _recurseStepExecutorInsert( workflowID_, existingStepExecutor_, iteration_ );
//     }

//     return true;
//   }

//   function insertStepExecutorInWorkflow( bytes4 workflowID_, address stepExecutorAddressesToInsert_, uint256 index_ ) external override onlyManager() returns ( bool ) {
//     return _insertStepExecutorInWorkflow( workflowID_, stepExecutorAddressesToInsert_, index_ );
//   }
// }