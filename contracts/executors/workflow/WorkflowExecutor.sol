// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./interfaces/IWorkflowExecutor.sol";

// Specifically has no storage to be manipulated.
contract WorkflowExecutor 
  // is IWorkflowExecutor
{

  // function executeStep( address stepExecutor_, bytes4 functionSelector_, bytes calldata arguements_ ) external returns ( bytes calldata callResult_ ) {
  //   return stepExecutor_.delegatecall( abi.encodeWithSelector( functionSelector_, arguements_) );
  // }
}