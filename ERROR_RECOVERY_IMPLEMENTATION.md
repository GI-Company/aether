# Error Recovery Implementation

**Status**: ✅ Complete (MVP)  
**Date**: November 29, 2025

## Overview

This document outlines the error recovery features implemented for AetherOS MindCell v2. The implementation adds three core capabilities to handle failures gracefully in complex task DAGs:

1. **Conditional Branching** (if-then-else logic)
2. **Error Handler Nodes** (fallback tasks)
3. **Exponential Backoff with Jitter** (intelligent retries)

---

## 1. Conditional Branching (If-Then-Else Logic)

### Purpose
Enable tasks to branch execution based on output conditions or error states, moving beyond the MVP's simple cascade-on-fail pattern.

### Implementation

#### Types Added to `backend/mindcell/intent.go`

```go
// Task extended with conditional fields
type Task struct {
    // ... existing fields ...
    
    // Conditional execution
    Condition  *Condition `json:"condition,omitempty"`     // Conditional check
    OnSuccess  []string   `json:"on_success,omitempty"`   // Tasks if condition passes
    OnFailure  []string   `json:"on_failure,omitempty"`   // Tasks if condition fails
    
    // Error handling
    HandlesError string `json:"handles_error,omitempty"` // Which task's error this handles
    RetryPolicy  *RetryPolicy `json:"retry_policy,omitempty"`
}

// Condition defines branching logic
type Condition struct {
    Type       string                 // "output_check", "error_catch", "comparison"
    SourceTask string                 // Which task's output to check
    Operator   string                 // "contains", "equals", "gt", "lt", "error_occurred"
    Value      interface{}            // Value to compare against
    Path       string                 // JSON path in output (e.g., "status", "results.count")
}

// RetryPolicy for exponential backoff
type RetryPolicy struct {
    MaxRetries        int     // Maximum retry attempts
    InitialDelay      int     // Initial delay in ms
    MaxDelay          int     // Max delay cap
    BackoffMultiplier float64 // Exponential factor (e.g., 2.0)
    JitterFraction    float64 // Randomization 0-1
}
```

### Condition Types

#### 1. Error Catch
Detects if a task succeeded or failed:
```json
{
  "type": "error_catch",
  "operator": "error_occurred"  // or "success"
}
```

#### 2. Output Check
Inspects task output values:
```json
{
  "type": "output_check",
  "operator": "contains",      // or "equals", "not_equals"
  "path": "text",              // JSON path in output
  "value": "expected_pattern"
}
```

#### 3. Comparison
Numeric/string comparisons:
```json
{
  "type": "comparison",
  "operator": "gt",            // "gt", "gte", "lt", "lte"
  "path": "confidence_score",
  "value": 0.8
}
```

### Example: Drug Research with Fallback

**Scenario**: If KG query fails, fallback to text search.

```json
{
  "tasks": [
    {
      "id": "kg_query",
      "type": "kg_query",
      "cell_type": "kg",
      "input": {"query": "aspirin interactions"},
      "on_failure": ["text_search"]  // Fallback task
    },
    {
      "id": "text_search",
      "type": "reasoning",
      "input": {"prompt": "Search pubmed for aspirin interactions"},
      "handles_error": "kg_query"  // Explicitly handles kg_query failure
    },
    {
      "id": "analysis",
      "type": "reasoning",
      "input": {"prompt": "Analyze results from: {{kg_query.output}} or {{text_search.output}}"},
      "depends_on": ["kg_query", "text_search"]
    }
  ]
}
```

### Example: Conditional Branching on Output

**Scenario**: Route high-confidence results vs. low-confidence for manual review.

```json
{
  "tasks": [
    {
      "id": "kg_query",
      "type": "kg_query",
      "condition": {
        "type": "comparison",
        "operator": "gte",
        "path": "confidence",
        "value": 0.9
      },
      "on_success": ["generate_report"],     // High confidence
      "on_failure": ["manual_review"]        // Low confidence
    },
    {
      "id": "generate_report",
      "type": "reasoning"
    },
    {
      "id": "manual_review",
      "type": "error_handler"
    }
  ]
}
```

---

## 2. Error Handler & Condition Evaluator

### File: `backend/mindcell/error_recovery.go`

#### ConditionEvaluator
Evaluates conditions against task results:

```go
evaluator := NewConditionEvaluator()

// Evaluate a condition
satisfied, err := evaluator.Evaluate(condition, taskResult)

// Extract values from nested JSON paths
value := evaluator.getValueFromPath(output, "results.count")
```

**Supported Operators**:
- `error_occurred` / `success` - Error state checks
- `contains` / `equals` / `not_equals` - String operations
- `gt` / `gte` / `lt` / `lte` - Numeric comparisons

#### ErrorHandler
Handles task failures and routes to appropriate handlers:

```go
handler := NewErrorHandler()

// Get next tasks after failure
nextTasks, shouldRetry := handler.HandleError(failedTask, result, allTasks)

// Evaluate conditional branches
nextTasks, err := handler.EvaluateConditionalBranch(task, result, allTasks)
```

### Integration in Executor

**File**: `backend/mindcell/executor.go`

The Executor now uses error recovery:

```go
type Executor struct {
    factory      *Factory
    executions   map[string]*Execution
    errorHandler *ErrorHandler         // NEW
    condEval     *ConditionEvaluator   // NEW
}
```

After task completion, conditions are evaluated:

```go
// Handle conditional branching on success
if task.Condition != nil {
    nextTasks, condErr := e.errorHandler.EvaluateConditionalBranch(task, result, execution.Intent.Tasks)
    if condErr == nil && len(nextTasks) > 0 {
        // Route to conditional tasks
        execution.addEvent("branching", task.ID, fmt.Sprintf("Branching to %d tasks", len(nextTasks)))
    }
}
```

---

## 3. Exponential Backoff with Jitter

### File: `backend/server/task_engine.go`

#### Implementation

Added two functions for intelligent retry:

```go
// exponentialBackoffRetry executes a function with exponential backoff
func exponentialBackoffRetry(ctx context.Context, maxRetries int, initialDelayMs int, 
    maxDelayMs int, backoffMultiplier float64, jitterFraction float64, fn func() error) error

// calculateBackoffDelay computes: delay = initialDelay * (multiplier ^ attempt)
//   with jitter to avoid thundering herd
func calculateBackoffDelay(attempt int, initialDelayMs int, maxDelayMs int, 
    backoffMultiplier float64, jitterFraction float64) int
```

#### Algorithm

```
Delay Calculation:
  base_delay = initialDelayMs * (backoffMultiplier ^ attempt)
  base_delay = min(base_delay, maxDelayMs)  // Cap at max
  
  if jitterFraction > 0:
    jitter = base_delay * jitterFraction * (2*random() - 1)
    delay = base_delay + jitter  // Add randomization
  
  return max(delay, initialDelayMs)  // Ensure minimum
```

#### Example Configuration

```json
{
  "retry_policy": {
    "max_retries": 3,
    "initial_delay_ms": 100,
    "max_delay_ms": 10000,
    "backoff_multiplier": 2.0,
    "jitter_fraction": 0.1
  }
}
```

**Retry Sequence** (100ms base, 2x multiplier, 10% jitter):
- Attempt 0: 100ms ± 10ms
- Attempt 1: 200ms ± 20ms
- Attempt 2: 400ms ± 40ms
- Attempt 3: 800ms ± 80ms

#### Integration in TaskEngine

The task engine now supports both legacy retry and new exponential backoff:

```go
if node.RetryPolicy != nil {
    // NEW: Exponential backoff with jitter
    err = exponentialBackoffRetry(tr.ctx, 
        node.RetryPolicy.MaxRetries,
        node.RetryPolicy.InitialDelayMs,
        node.RetryPolicy.MaxDelayMs,
        node.RetryPolicy.BackoffMultiplier,
        node.RetryPolicy.JitterFraction,
        func() error {
            return te.execNode(tr, node)
        })
} else {
    // Fallback: Legacy simple retry for backward compatibility
    for attempt := 0; attempt <= max(0, node.Retries); attempt++ {
        err = te.execNode(tr, node)
        if err == nil { break }
        if attempt < max(0, node.Retries) {
            time.Sleep(100 * time.Millisecond)
        }
    }
}
```

---

## 4. Test Coverage

**File**: `backend/mindcell/error_recovery_test.go`

### Tests Implemented

✅ **TestConditionEvaluator_ErrorCatch** (3 cases)
- error_occurred on failed task
- success on completed task
- error_occurred on successful task returns false

✅ **TestConditionEvaluator_OutputCheck** (3 cases)
- contains operator
- equals operator
- contains with no match

✅ **TestConditionEvaluator_Comparison** (3 cases)
- greater than
- less than
- greater than or equal

✅ **TestGetValueFromPath** (3 cases)
- simple path
- nested path
- non-existent path

✅ **TestErrorHandler_HandleError**
- Routes to error handlers on failure

✅ **TestErrorHandler_EvaluateConditionalBranch**
- Evaluates condition and routes to success task

✅ **TestRetryPolicyDefaults**
- Validates retry policy structure

**All tests passing**: ✅

---

## 5. Usage Examples

### Pattern 1: Parallel Primaries with Fallback

```json
{
  "intent": "Analyze drug interactions with automatic fallback",
  "tasks": [
    {
      "id": "kg_query",
      "type": "kg_query",
      "cell_type": "kg",
      "on_failure": ["fallback_search"]
    },
    {
      "id": "fallback_search",
      "type": "reasoning",
      "input": {"prompt": "Search for: aspirin side effects"}
    },
    {
      "id": "synthesize",
      "type": "hybrid",
      "depends_on": ["kg_query", "fallback_search"],
      "input": {
        "prompt": "Combine KG and text results"
      }
    }
  ]
}
```

### Pattern 2: Quality-Based Branching

```json
{
  "id": "analysis",
  "condition": {
    "type": "comparison",
    "operator": "gte",
    "path": "quality_score",
    "value": 0.85
  },
  "on_success": ["publish_report"],
  "on_failure": ["manual_review", "refinement"]
}
```

### Pattern 3: Smart Retries

```json
{
  "id": "kg_query",
  "retry_policy": {
    "max_retries": 5,
    "initial_delay_ms": 500,
    "max_delay_ms": 30000,
    "backoff_multiplier": 2.0,
    "jitter_fraction": 0.2
  }
}
```

---

## 6. Benefits Over MVP

| Feature | MVP | v2 |
|---------|-----|-----|
| **Error Handling** | Cascade-on-fail (all downstream skip) | Conditional branching + fallback handlers |
| **Retry Strategy** | Simple (no delay) or fixed | Exponential backoff + jitter |
| **Output-Based Routing** | ❌ Not supported | ✅ Conditions on output path/value |
| **Error Handlers** | ❌ Not supported | ✅ Dedicated error_handler tasks |
| **User Workarounds** | Manual retry loop | Framework-native |

---

## 7. Roadmap (Future v3)

- [ ] Circuit breaker pattern (fail fast after N consecutive errors)
- [ ] Dynamic task injection (create tasks based on results)
- [ ] Result caching/memoization (skip re-execution)
- [ ] Parallel error handlers with quorum voting
- [ ] Timeout per condition evaluation

---

## 8. Files Modified/Created

### Modified
- `backend/mindcell/intent.go` - Added Condition, RetryPolicy types
- `backend/mindcell/executor.go` - Integrated error recovery
- `backend/server/task_engine.go` - Added exponential backoff

### Created
- `backend/mindcell/error_recovery.go` - Core error handling logic
- `backend/mindcell/error_recovery_test.go` - Comprehensive tests

---

## Testing

Run tests:
```bash
cd backend
go test ./mindcell -run "TestErrorHandler|TestConditionEvaluator|TestGetValueFromPath" -v
```

All tests pass ✅
