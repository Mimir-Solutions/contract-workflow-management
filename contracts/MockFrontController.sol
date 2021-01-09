// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./MockStorage.sol";
import "./MockRegistry.sol";

contract MockFrontController {

  function executeWorkflowWithInterfaces( address target_, string calldata inputMessage_, uint8 inputNumber_ ) public {
    console.log( "Testing using interfaces." );

    console.log( "Setting message to %s.", inputMessage_);
    MockStorage( target_ ).setMessage( inputMessage_ );
    console.log( "Set message to %s.", MockStorage( target_ ).message() );

    
    console.log( "Setting number to %s.", inputNumber_);
    MockStorage( target_ ).setNumber( inputNumber_ );
    console.log( "Set number to %s.", MockStorage( target_ ).number() );

    console.log( "Tested using interfaces." );
  }

  function executeWorkflowWithSelectors( address target_, address registry_, string calldata inputMessage_, uint8 inputNumber_ ) public {
    console.log( "Testing using Selectors." );

    bytes4[] memory workflow_ = MockRegistry( registry_ ).getWorkflow();

    ( bool succeeded_, bytes memory result_ ) = target_.call( abi.encodeWithSelector( workflow_[0], inputMessage_ ) );
    ( succeeded_, result_ ) = target_.call( abi.encodeWithSelector( workflow_[1], inputNumber_ ) );

    console.log( "Completed workflow execution." );
    console.log( "Set message to %s.", MockStorage( target_ ).message() );
    console.log( "Set number to %s.", MockStorage( target_ ).number() );

    console.log( "Tested using interfaces." );
  }
}