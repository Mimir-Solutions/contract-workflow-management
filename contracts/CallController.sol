// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./MockStorage.sol";
import "./MockRegistry.sol";

contract Caller {

  function executeWorflow( address registry, address target ) public returns ( string memory ) {

    console.log( "Setting message." );
    string memory message_ = "Hello World";
    console.log( "Set message." );

    bytes[] memory arguments_;

    // arguments_[0] = abi.encode(0);
    console.log( "Setting second argument in array." );
    arguments_[0] = abi.encode(message_);
    console.log( "Sett second argument in array." );

    console.log( "Getting workflow.");
    bytes4[] memory workflow_ = MockRegistry(registry).getWorkflow();
    console.log( "Got workflow.");

    bool succeeded;
    bytes memory returnValue_;

    console.log( "Starting workflow execution." );
    for( uint256 iteration_ = 0; workflow_.length > iteration_; iteration_++ ) {
      console.log( "Executing workflow step %s.", iteration_ );
      ( succeeded, returnValue_ ) = target.call(
        abi.encodeWithSelector( workflow_[iteration_], arguments_[iteration_] )
      );
      console.log( "Executed workflow step %s", iteration_ );
    }

    return string( returnValue_ );
  }

  // function getCalleeFunctionSelector() public pure returns ( bytes4 ) {
  //   return Storage.setMessage.selector;
  // }

  // function getCalleeFunctionSelector2() public pure returns ( bytes4 ) {
  //   return Storage.message.selector;
  // }


  // function delegateCall( address callee_ ) public {
  //   string memory delegateMessage_ = "Hello World";

  //   callee_.delegatecall(
  //     abi.encodeWithSelector( getCalleeFunctionSelector(), delegateMessage_ )
  //   );
  // }

  // function delegateCallRead( address callee_ ) public returns ( bool, bytes memory ) {

  //   return callee_.delegatecall(
  //     abi.encodeWithSelector( getCalleeFunctionSelector2() )
  //   );
  // }

  // fallback(address implementation) internal {
  //   // solhint-disable-next-line no-inline-assembly
  //   assembly {
  //     // Copy msg.data. We take full control of memory in this inline assembly
  //     // block because it will not return to Solidity code. We overwrite the
  //     // Solidity scratch pad at memory position 0.
  //     calldatacopy(0, 0, calldatasize())

  //     // Call the implementation.
  //     // out and outsize are 0 because we don't know the size yet.
  //     let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

  //     // Copy the returned data.
  //     returndatacopy(0, 0, returndatasize())

  //     switch result
  //     // delegatecall returns 0 on error.
  //     case 0 { revert(0, returndatasize()) }
  //     default { return(0, returndatasize()) }
  //   }
  // }
}
