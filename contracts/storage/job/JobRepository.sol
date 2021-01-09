// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

import "hardhat/console.sol";

import "./interfaces/IJobRegistry.sol";

import "../../dependencies/holyzeppelin/contracts/security/access/Ownable.sol";
import "../../dependencies/holyzeppelin/contracts/introspection/ERC1820/ERC1820Registrar.sol";

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

contract JobRegistry is IJobRegistry, ERC1820Registrar, Ownable {

  /*
   * TODO Update to Natspec comment
   * Job consists of an array of function selectors in the order to execute and an array of addresses on which to execute.
   * Job ID can be calculated using the following conversion.
   * byes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) )
   */
  /*
   * TODO Update to Natspec comment
   * Initial implementation optimizes Jobs to simply an array of function selectors and an array of address on which to execute in the eorder of execution.
   * The intention is to enable future extension with a more granular defintion of a Job.
   * Job ID can be calculated using the following conversion.
   * bytes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) . . . )
   */
  mapping( bytes32 => address[] ) public stepExecutorAddressesforJobID;

  /*
   * TODO Update to Natspec comment
   * Job consists of an array of function selectors in the order to execute and an array of addresses on which to execute.
   * Job ID can be calculated using the following conversion.
   * byes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) )
   */
  /*
   * TODO Update to Natspec comment
   * Initial implementation optimizes Jobs to simply an array of function selectors and an array of address on which to execute in the eorder of execution.
   * The intention is to enable future extension with a more granular defintion of a Job.
   * Job ID can be calculated using the following conversion.
   * bytes32( bytes32( address ^ bytes32( <Function Selector> ) ) ^ bytes32( address ^ bytes32( <Function Selector> ) ) . . . )
   */
  mapping( bytes32 => bytes4[] ) public stepFunctionSelectorsForJobID;

  // TODO test registering my won registry in universal ERC1820 Registery.
  // TODO inplement constructor that registers is iterfaces as a ERC1820Implementer.

  // TODO replace with calculated value.
  bytes4 constant public JOB_REGISTRY_INTERFACE_ERC165_ID = 
      bytes4(keccak256("encodeJobID(address[],bytes4[])"))
      ^ bytes4(keccak256("encodeFunctionSelector(string)"))
      ^ bytes4(keccak256("encodeFunctionSelectors(string[])"))
      ^ bytes4(keccak256("registerJob(bytes32,address[],bytes4[])"))
      ^ bytes4(keccak256("registerJob(address[],bytes4[])"))
      ^ bytes4(keccak256("registerJob(address[],string[])"));

  bytes32 constant public JOB_REGISTRY_INTERFACE_ERC1820_ID = keccak256( "JobRegistry" );

  

  constructor(
     address[] memory registriesToRegisterWith_
  ) 
    ERC1820Registrar( 
      registriesToRegisterWith_,
      address(this)
    ) 
  {
    console.log("Instantiating JobRegistry.");

    console.log("JOB_REGISTRY_INTERFACE_ERC165_ID interface ID: %s", address( uint256( bytes32( JOB_REGISTRY_INTERFACE_ERC165_ID ) ) ) );
    console.log("JOB_REGISTRY_INTERFACE_ERC1820_ID interface ID: %s", address( uint256( bytes32( JOB_REGISTRY_INTERFACE_ERC1820_ID ) ) ) );

    console.log("Registering WorkflowRegistry ERC165 interface ID with self.");
    console.log("WorkflowRegistry interface ERC165 ID: %s", address( uint256( bytes32( JOB_REGISTRY_INTERFACE_ERC165_ID ) ) ) );
    _registerInterface( JOB_REGISTRY_INTERFACE_ERC165_ID );
    console.log("Registered WorkflowRegistry ERC165 interface ID with self.");

    console.log("Registering WorkflowRegistry ERC1820 interface ID of %s for %s with self.", address( uint256( JOB_REGISTRY_INTERFACE_ERC1820_ID) ), address(this));
    _registerInterfaceForAddress( JOB_REGISTRY_INTERFACE_ERC1820_ID, address(this) );
    console.log("Registered WorkflowRegistry ERC1830 interface ID with self.");

    console.log("Instantiated JobRegistry.");
  }
  
  /*
   * TODO Update to Natspec comment
   * Intended to provide consistent encoding of Job IDs.
   */
  function _encodeJobID( address[] memory stepExecutorAddresses_, bytes4[] memory stepExecutorFunctionSelectors_ ) internal pure returns ( bytes32 ) {
    require( stepExecutorAddresses_.length == stepExecutorFunctionSelectors_.length, "There must be a step executor address for every step." );

    bytes32 jobID_;
    for( uint256 iteration_ = 0; stepExecutorFunctionSelectors_.length > iteration_; iteration_ ) {
      jobID_ = bytes32( jobID_ ^ bytes32( bytes32( uint256( stepExecutorAddresses_[iteration_] ) ) ^ bytes32( stepExecutorFunctionSelectors_[iteration_] ) ) );
    }

    return jobID_;
  }

  /*
   * TODO Update to Natspec comment
   * Exposes internal function that provided consistent encoding of job IDs.
   */
  function encodeJobID( address[] memory stepExecutorAddresses_, bytes4[] memory stepExecutorFunctionSelectors_ ) external pure override returns ( bytes32 ) {
    return _encodeJobID( stepExecutorAddresses_, stepExecutorFunctionSelectors_ );
  }

  /*
   * TODO Update to Natspec comment
   * Intended to provide consistent encoding of function selectors.
   */
  function _encodeFunctionSelector( string memory functionSignatureToEncode_ ) internal pure returns ( bytes4 ) {
    return bytes4( keccak256( bytes( functionSignatureToEncode_ ) ) );
  }

  /*
   * TODO Update to Natspec comment
   * Exposes internal function that provided consistent encoding of function selectors.
   */
  function encodeFunctionSelector( string calldata functionSignatureToEncode_ ) external pure override returns ( bytes4 ) {
    return _encodeFunctionSelector( functionSignatureToEncode_ );
  }

  function _encodeFunctionSelectors( string[] memory functionSignaturesToEncode_ ) internal pure returns ( bytes4[] memory ) {
    bytes4[] memory encodedFunctionSelectors_;
    for( uint256 iteration_ = 0; functionSignaturesToEncode_.length > iteration_; iteration_++ ) {
      encodedFunctionSelectors_[iteration_] = _encodeFunctionSelector( functionSignaturesToEncode_[iteration_] );
    }

    return encodedFunctionSelectors_;
  }

  function encodeFunctionSelectors( string[] memory functionSignaturesToEncode_ ) external pure override returns ( bytes4[] memory ) {
    return _encodeFunctionSelectors( functionSignaturesToEncode_ );
  }

  function _registerJob( bytes32 jobIDToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes4[] memory stepExecutorFunctionSelectorsToRegister_ ) internal {
    stepExecutorAddressesforJobID[jobIDToRegister_] = stepExecutorAddressesToRegister_;
    stepFunctionSelectorsForJobID[jobIDToRegister_] = stepExecutorFunctionSelectorsToRegister_;
  }

  function registerJob( bytes32 jobIDToRegister_, address[] memory stepExecutorAddressesToRegister_, bytes4[] calldata stepExecutorFunctionSelectorsToRegister_ ) external override {
    _registerJob( jobIDToRegister_, stepExecutorAddressesToRegister_, stepExecutorFunctionSelectorsToRegister_ );
  }

  function registerJob( address[] memory stepExecutorAddressesToRegister_, bytes4[] memory stepExecutorFunctionSelectorsToRegister_ ) external override {
    _registerJob( _encodeJobID( stepExecutorAddressesToRegister_, stepExecutorFunctionSelectorsToRegister_ ), stepExecutorAddressesToRegister_, stepExecutorFunctionSelectorsToRegister_ );
  }

  function registerJob( address[] memory stepExecutorAddressesToRegister_, string[] memory stepExecutorFunctionSelectorsToRegister_ ) external override {
    bytes4[] memory encodedFunctionSelectors_ =  _encodeFunctionSelectors( stepExecutorFunctionSelectorsToRegister_ );
    _registerJob( _encodeJobID( stepExecutorAddressesToRegister_, encodedFunctionSelectors_ ), stepExecutorAddressesToRegister_, encodedFunctionSelectors_ );
  }

  function _getJobForJobID( bytes32 jobID_ ) internal view returns ( address[] storage, bytes4[] storage ) {
    return ( stepExecutorAddressesforJobID[jobID_], stepFunctionSelectorsForJobID[jobID_] );
  }

  function getJobForJobID( bytes32 jobID_ ) external view override returns ( address[] memory, bytes4[] memory ) {
    return _getJobForJobID( jobID_ );
  }

}