// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./MockStorage.sol";

contract MockRegistry {

  bytes4[] private _workflow;

  constructor() {
    console.log( "Getting workflow step 1." );
    _workflow.push( MockStorage.setMessage.selector );
    console.log( "Getting workflow step 2." );
    _workflow.push( MockStorage.setNumber.selector );
  }

  function getWorkflow() external view returns ( bytes4[] memory ) {
    console.log( "Sending workflow." );
    return _workflow;
  }
}