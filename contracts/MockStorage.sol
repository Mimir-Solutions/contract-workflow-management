// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

contract MockStorage {

  string private _message;

  uint8 private _number;

  function message() public  view returns ( string memory ) {
    console.log( "Getting message of %s.", _message );
    return _message;
  }

  function setMessage( string calldata newMessage_ ) external {
    console.log( "Setting message to %s.", newMessage_ );
    _message = newMessage_;
    console.log( "Set message to %s.", _message );
  }

  function number() public view returns ( uint8 ) {
    console.log( "Getting number of %s.", _number );
    return _number;
  }

  function setNumber( uint8 newNumber_ ) external {
    console.log( "Setting number to %s.", newNumber_ );
    _number = newNumber_;
    console.log( "Set number to %s.", newNumber_ );
  }
}