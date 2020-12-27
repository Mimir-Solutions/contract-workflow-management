// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

import "../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820EnhancedRegistry.sol";
import "../dependencies/holyzeppelin/contracts/access/Ownable.sol";
import "../datatypes/workflow/Workflow.sol";
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
contract WorkflowRegistry is ERC1820EnhancedRegistry, Ownable {

  using Workflow for Workflow.Step;
  using EnumerableSet for EnumerableSet.AddressSet;
  using Address for address;

  bytes4 public immutable INVALID_FUNCTION_SELECTOR;
  bytes32 public immutable INVALID_ERC1820_INTERFACE_ID;
  bytes32 public immutable INVALID_STEP_ID;

  bytes4 immutable public WORFLOW_REGISTRY_INTERFACE_ERC165_ID;
  bytes32 immutable public WORFLOW_REGISTRY_INTERFACE_ERC1820_ID;

  bytes32[] public _stepIDs;

  mapping( bytes32 => Step ) private _stepForStepID;

  mapping( bytes32 => EnumerableSet.AddressSet ) private _stepExecutors;

  /**
   * bytes32 = WorkflowID is bytes32(byes32(STEP_EXECUTOR_ERC1820_INTERFACE_ID) ^ bytes32(FUNCTION_SELECTOR)) ^ bytes32(byes32(STEP_EXECUTOR_ERC1820_INTERFACE_ID) ^ bytes32(FUNCTION_SELECTOR)) . . .
   *  Repeat function selectors for each pair
   */
  mapping( bytes32 => bytes32[] ) private _workflowForWorkflowID;

  bytes32[] public workflows;
  mapping( bytes32 => uint256 ) public workflowIndexes;

  constructor () {
    console.log("Instantiating WorkflowRegistry.");

    INVALID_FUNCTION_SELECTOR = bytes4(keccak256("0"));
    INVALID_ERC1820_INTERFACE_ID = bytes32(keccak256(0));
    INVALID_STEP_ID = bytes32( bytes32(keccak256(0)) ^ bytes32(bytes4(keccak256("0"))) );

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

    console.log("Instantiated WorkflowRegistry.");
  }

  function registerStepID( string memory erc1820InterfaceIDToEncode_, string memory functionSignature_ ) internal onlyOwner() {
    return _registerStepID( erc1820InterfaceIDToEncode_, functionSignature_ )
  }

  function _registerStepID( string storage erc1820InterfaceIDToEncode_, string storage functionSignature_ ) internal onlyOwner() returns ( bytes32 stepIDToRegister_ ) {

    bytes32 encodedERC1820InterfaceID_ = _encodeERC1820InterfaceID( erc1820InterfaceIDToEncode_ );
    require( _confirmValidERC1820InterfaceID( encodedERC1820InterfaceID_ ) );

    bytes4 encodedFunctionSignature_ = _encodeFunctionSelector( functionSignature_ );
    require( _confirmValidFunctionSelector( functionSignature_ ) );

    bytes32 stepIDToRegister_ = _encodeStepID( encodedERC1820InterfaceIDToEncode_, encodedFunctionSignature_ );
    require( _confirmValidStepID( stepIDToRegister_ ) );

    _stepForStepID[stepIDToRegister_].addStep( true, stepIDToRegister_, encodedERC1820InterfaceIDToEncode_, encodedFunctionSignature_ );
    _stepIDs.push(stepIDToRegister_);
  }

  function _confirmValidFunctionSelector( bytes4 functionSelectorToValidate_ ) internal pure returns ( bool isValiedFunctionSelector_ ) {
    return ( functionSelectorToValidate_ != INVALID_FUNCTION_SELECTOR );
  }

  function _confirmValidERC1820InterfaceID( bytes32 erc1820InterfaceIDToValidate_ ) internal pure returns ( bool isValidERC1820InterfaceID_ ) {
    return ( erc1820InterfaceIDToValidate_ != INVALID_ERC1820_INTERFACE_ID );
  }

  function _encodeERC1820InterfaceID( string memory erc1820InterfaceIDToEncode_ ) internal pure returns ( bytes32 encodedERC1820InterfaceID_ ) {
    return bytes32( keccak256( erc1820InterfaceIDToEncode_ ) );
  }

  function _encodeFunctionSelector( string memory functionSignature_ ) internal pure returns ( bytes4 functionSelectior_ ) {
    return bytes4( keccak256( bytes( functionSignature_ ) ) );
  }

  function _confirmValidStepID( bytes32 stepIDToValidate_ ) internal pure returns ( bool isStepIDValid_ ) {
    return ( stepIDToValidate_ != INVALID_STEP_ID );
  }

  function _encodeStepID( bytes32 memory erc1820InterfaceIDToEncode_, bytes4 memory functionSignature_ ) internal pure returns ( bytes32 encodedStepID_ ) {
    return bytes32( erc1820InterfaceIDToEncode_ ^ functionSignature_ );
  }

  function _getStep( bytes32 stepID_ ) internal view returns ( bytes32 stepInterfaceID_, bytes4 stepFunctionSelector_ ) {
    return ( _stepForStepID_[stepID_]._interfaceID, _stepForStepID[stepID_]._functionSelector );
  }

  function getStep( bytes32 stepID_ ) external view returns ( bytes32 memory stepInterfaceID_, bytes4 stepFunctionSelector_ ) {
    return _getStep( stepID_ );
  }

  /**
   * Returns 2 arrays of the interface ID and function selectors in the same order as provided.
   */
  function _getSteps( bytes32[] stepIDs_ ) internal view returns ( bytes32[] memory stepInterfaceIDs_, bytes4[] memory stepFunctionSelectors_ ) {
    bytes32[] memory stepInterfaceIDs_;
    bytes4[] memory stepFunctionSelectors_;

    for( iteration_ = 0; ( stepIDs_.length -1 ) >= iteration_ ; iteration++ ) {
      ( bytes32 stepInterfaceID_, bytes4 stepFunctionSelector_ ) = _getStep( stepIDs_[iteration_] );
      stepInterfaceIDs_.push(stepInterfaceID_);
      stepFunctionSelectors_.push(stepFunctionSelector_);
    }
  }

  function getSteps( bytes32[] stepIDs_ ) internal view returns ( bytes32[] memory stepInterfaceIDs_, bytes4[] memory stepFunctionSelectors_ ) {
    return _getSteps( stepIDs_ );
  }

  function getAllSteps() external view returns ( bytes32[] stepIDs_ ) {
    return _stepIDs;
  }

  function registerStepExecutor( address stepExecutorAddress_, string stepExecutor1820InterfaceID_, string stepExecutorFunctionSelector_ ) external onlyOwner() {
    bytes32 encodedERC1820InterfaceID_ = _encodeERC1820InterfaceID( stepExecutor1820InterfaceID_ );
    require( _stepExecutorExists( stepExecutorAddress_, encodedERC1820InterfaceID_) );
    require( stepExecutorAddress_.isContract() );
    require( _confirmValidERC1820InterfaceID( encodedERC1820InterfaceID_ ) );
    _requireImplementsERC1820Interface( stepExecutorAddress_, stepExecutorAddress_, encodedERC1820InterfaceID_ );
    _registerStepExecutor( stepExecutorAddress_, encodedERC1820InterfaceID_ );
  }

  function deregisterStepExecutor( address stepExecutorAddress_, bytes32 stepExecutor1820InterfaceID_ ) external onlyOwner() {
    require( IERC20Impementer( address( this ) ).canImplementInterfaceForAddress( _encodeERC1820InterfaceID( stepExecutor1820InterfaceID_ ), Context._msgSender() ) == ERC1820_ACCEPT_MAGIC );
    _stepExecutors[stepExecutor1820InterfaceID_].remove(stepExecutorAddress_);
  }

  function _stepExecutorExists( address stepExecutorAddress_, bytes32 stepExecutor1820InterfaceID_) internal view returns ( bool ) {
    return _stepExecutors[stepExecutor1820InterfaceID_].contains(stepExecutorAddress_);
  }

  function _registerStepExecutor( address stepExecutorAddress_, bytes32 stepID_ ) internal {
    _stepExecutors[_encodeStepExecutorID( stepExecutorAddress_, stepExecutor1820InterfaceID_, functionSelector_ )].add(stepExecutorAddress_);
  }

  function _getStepExecutor( bytes32 stepID_ ) internal view returns ( address stepExecutorAddress_ ) {
    return _stepExecutors[stepID_];
  }

  function getStepExecutor( bytes32 stepID_ ) internal view returns ( address stepExecutorAddress_ ) {
    return _getStepExecutor( stepID_ );
  }

  function _getStepExecutors( bytes32[] stepIDs_ ) internal view returns ( address[] stepExecutors_ ) {
    address[] stepExecutors_;
    for( iteration_ = 0; ( stepIDs_.length - 1 ) >= iteration_; iteration_++ ) {
      stepExecutors_.push(_getStepExecutor( stepIDs_[iteration_] ) );
    }
  }

  function registerWorkflow( bytes32 workflowID_, bytes32[] stepIDs_ ) external onlyOwner() {
    _registerWorkflow( workflowID_, encodedStepIDs_ );
  }

  function _registerWorkflow( bytes32 workflowID_, bytes32[] stepIDs_ ) internal {
    _workflowForWorkflowID[workflowID_] = workflow_;
    workflows.push(workflow_);
    workflowIndexes[workflowID_] = ( workflows.length -1 );
  }

  function registerWorkflow( string[] workflowERC1820InterfaaceIDs_, string[] workflowFunctionSelectors_ ) public onlyOwner() {
    _registerStepIDs( workflowERC1820InterfaaceIDs_, workflowFunctionSelectors_ );
    ( bytes32 workflowID_, bytes32[] encodedStepIDs_ ) = _encodeWorkflow( workflowERC1820InterfaaceIDs_, workflowFunctionSelectors_ );
     _registerWorkflow( workflowID_, encodedStepIDs_ );
  }

  function _registerStepIDs( string[] workflowERC1820InterfaaceIDs_, string[] workflowFunctionSelectors_ ) internal onlyOwner() {
    require( workflowERC1820InterfaaceIDs_.length == workflowFunctionSelectors_.length );
    for( iteration_ = 0; ( workflowERC1820InterfaaceIDs_.length - 1 ) >= iteration_; iteration_++ ) {
      _registerStepID( workflowERC1820InterfaaceIDs_[iteration_], workflowFunctionSelectors_[iteration_] );
    }
  }

  function _encodeWorkflow( string[] workflowERC1820InterfaaceIDs_, string[] workflowFunctionSelectors_ ) internal pure returns ( bytes32 workflowID_, bytes32[] stepIDs_ ) {
    require( ( workflowERC1820InterfaaceIDs_.length == workflowFunctionSelectors_.length ) );
    bytes32 workflowID_;
    bytes32[] stepIDs_;
    for( iteration_ = 0; ( workflowERC1820InterfaaceIDs_.length -1 ) >= iteration_; iteration_ ) {
      bytes32 stepID_ = _encodeStepID( _encodeERC1820InterfaceID( workflowERC1820InterfaaceIDs_[iteration_] ), _encodeFunctionSelector( workflowFunctionSelectors_[iteration_] ) );
      stepIDs_.push(stepID_);
      workflowID_ = bytes32( workflowID_ ^ stepID_ );
    }
  }

  function _getWorkflow( bytes32 workflowID_ ) internal view returns ( bytes32[] workflow_ ) {
    return _workflowForWorkflowID[workFlowID_];
  }

  function getWorkflow( bytes32 workflowID_ ) external view returns ( bytes32[] workflow_ ) {
    return _getWorkflow( workflowID_ );
  }

  function _setDefaultStepExecutor( address stepExecutorAddress_, string stepExecutor1820InterfaceID_ ) internal {
    _setInterfaceImplementer( Context._msgSender(), _interfaceHash, _implementer );
  }

  function setDefaultStepExecutor( address stepExecutorAddress_, string stepExecutor1820InterfaceID_ ) external onlyOwner() {
    require( stepExecutorAddress_.isContract() );
    bytes32 encodedStepExecutor1820InterfaceID_ = _encodeERC1820InterfaceID( stepExecutor1820InterfaceID_ );
    require( _stepExecutorExists( address stepExecutorAddress_, bytes32 encodedStepExecutor1820InterfaceID_ ) );
    _setDefaultStepExecutor( stepExecutorAddress_, encodedStepExecutor1820InterfaceID_ );
  }
}