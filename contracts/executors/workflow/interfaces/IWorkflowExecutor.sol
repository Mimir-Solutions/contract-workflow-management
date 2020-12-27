// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

// Specifically has no storage to be manipulated.
contract WorkflowExecutor is IWorkflowExecutor {

  function executeStep( address stepExecutor_, bytes4 functionSelector_, bytes arguements_ ) external returns ( bytes callResult_ );
}