// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import "../src/L2ReplayPoC.sol";

// Mock batcher contract for testing
contract MockBatchInbox {
    bytes public lastSubmittedBatch;
    uint256 public batchCount;
    
    event BatchSubmitted(bytes data);
    
    function submitBatch(bytes calldata data) external {
        lastSubmittedBatch = data;
        batchCount++;
        emit BatchSubmitted(data);
    }
}

contract L2ReplayTest is Test {
    MockBatchInbox public mockBatcher;
    L2ReplayPoC public poc;

    function setUp() public {
        // Deploy mock batcher instead of using hardcoded address
        mockBatcher = new MockBatchInbox();
        poc = new L2ReplayPoC(address(mockBatcher));
    }

    function testInjectMaliciousBatch() public {
        bytes memory payload = hex"deadbeefcafebabe";
        
        // Test that the batch injection works
        poc.injectMaliciousBatch(payload);
        
        // Verify the batch was submitted to the mock batcher
        assertEq(mockBatcher.lastSubmittedBatch(), payload);
        assertEq(mockBatcher.batchCount(), 1);
    }
    
    function testMultipleBatchInjection() public {
        bytes memory payload1 = hex"deadbeef";
        bytes memory payload2 = hex"cafebabe";
        
        // Inject first batch
        poc.injectMaliciousBatch(payload1);
        assertEq(mockBatcher.batchCount(), 1);
        
        // Inject second batch
        poc.injectMaliciousBatch(payload2);
        assertEq(mockBatcher.batchCount(), 2);
        assertEq(mockBatcher.lastSubmittedBatch(), payload2);
    }
    
    function testReplayAttackScenario() public {
        // Simulate a replay attack scenario
        bytes memory legitimateBatch = hex"1234567890abcdef";
        bytes memory replayedBatch = legitimateBatch; // Same batch replayed
        
        // First submission (legitimate)
        poc.injectMaliciousBatch(legitimateBatch);
        assertEq(mockBatcher.batchCount(), 1);
        
        // Replay the same batch (this is the vulnerability)
        poc.injectMaliciousBatch(replayedBatch);
        assertEq(mockBatcher.batchCount(), 2); // Shows the replay succeeded
        
        // In a real system, this replay should be prevented
        console.log("ALERT: Replay attack successful - same batch processed twice!");
    }
}
