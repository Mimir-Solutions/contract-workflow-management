// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

// Specifically has no storage to be manipulated.
contract IWorkflowExecutor {

  function executeStep( address stepExecutor_, bytes4 functionSelector_, bytes calldata arguements_ ) external returns ( bytes calldata callResult_ );
}