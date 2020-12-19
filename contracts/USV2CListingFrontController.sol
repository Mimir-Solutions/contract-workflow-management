// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.0;

import "hardhat/console.sol";

contract USV2CLiquiditySwapFrontController {

  IWorkflowRegistry private _workflowRegistry;
  IWorkflowOrchestrator private _workflowOrchestrator;
  
  function adjustPrice(address _tokenToRaise, address[] memory _lpToSwap, uint256 _amountToAdjust, bool isLower) public returns (bool) {

  }
}