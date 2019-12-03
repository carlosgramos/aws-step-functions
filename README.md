# aws-step-functions

### References:
https://medium.com/weareservian/aws-step-functions-the-power-of-simplicity-10e8395af4f3
https://docs.aws.amazon.com/step-functions/latest/dg/concepts-activities.html
https://medium.com/weareservian/serverless-data-processing-with-aws-step-functions-an-example-6876e9bea4c0
https://github.com/servian/aws-step-function-example/blob/master/state-machine

### State Machine - High Level Concepts
- Lambda functions are a great way to create serverless architectures within AWS. But managing and orchestrating them can be difficult when we use many functions within a pipeline. 
- Managing long-running asynchronous processes is also a problem. Lambda can trigger processes to start, but we should avoid having them wait for long-running processes (more than a few minutes) to conclude. 
- AWS Step Functions is a solution to both these problems.
- StepFunctions are also known as "state machines."
- The state machine requires an IAM role to launch Lambda functions.
- After you create a state machine, you can start an execution. 
- State machines are defined using JSON text that represents a structure containing the following fields.
    - Comment (Optional): A human-readable description of the state machine.
    - StartAt (Required): A string that must exactly match (is case sensitive) the name of one of the state objects.
    - TimeoutSeconds (Optional): The maximum number of seconds an execution of the state machine can run. If it runs longer than the specified time, the execution fails with a States.Timeout Error Name.
    - Version (Optional): The version of the Amazon States Language used in the state machine (default is "1.0").
    - States (Required): An object containing a comma-delimited set of states.
- The States field contains States
```  javascript 
{
  "Comment": "A Hello World example of the Amazon States   
                Language using a Pass state",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Pass",
      "Result": "Hello World!",
      "End": true
    }
  }
}
```
- Each State in the States field also has it's own fields:
    - Type (Required): The state's type.
    - Next: The name of the next state that is run when the current state finishes. Some state types, such as Choice, allow multiple transition states.
    - End: Designates this state as a terminal state (ends the execution) if set to true. There can be any number of terminal states per state machine. Only one of Next or End can be used in a state. Some state types, such as Choice, don't support or use the End field.
    - Comment (Optional): Holds a human-readable description of the state.
    - InputPath (Optional): A path that selects a portion of the state's input to be passed to the state's task for processing. If omitted, it has the value $ which designates the entire input. For more information, see Input and Output Processing).
    - OutputPath (Optional): A path that selects a portion of the state's input to be passed to the state's output. If omitted, it has the value $ which designates the entire input. 
- A state machine can have the following states:
    - Pass - A Pass state ("Type": "Pass") passes its input to its output, without performing work.
        - A Pass state can have the following fields:
            - Result (Optional)
            - ResultPath (Optional)
            - Parameters (Optional)
    - Task - A Task state ("Type": "Task") represents a single unit of work performed by a state machine. 
        - All work in your state machine is done by tasks. 
        - A task performs work by using:
            - An activity
                - An activity consists of program code that waits for an operator to perform an action or to provide input. 
                - Activities are an AWS Step Functions feature that enables you to have a task in your state machine where the work is performed by a worker that can be hosted on: 
                    - Amazon Elastic Compute Cloud (Amazon EC2)
                    - Amazon Elastic Container Service (Amazon ECS)
                    - Mobile devices
                    - AWS Lambda function
                - Activities are a way to associate code running somewhere (known as an activity worker) with a specific task in a state machine.
                - Activity tasks are good in the event where we have tasks that need a long amount of time to complete.
                - Activity tasks were introduced to handle situations where a piece of code needs to run on an Amazon EC2 instance or even outside AWS ecosystem (e.g. on on-premise hardware). 
                - This is done by registering the process with an ARN and calling it from a state machine that then feeds the output back to the state machine on completion. 
                - Activities poll Step Functions using the following API actions:
                    - GetActivityTask 
                    - SendTaskSuccess
                    - SendTaskFailure
                    - SendTaskHeartbeat
                - Activities rely on A worker (code hosted on EC2, ECS, etc.) to complete it's task 
                - A worker is a program that is responsible for:
                    - Polling Step Functions for activities using the GetActivityTask API action.
                    - Performing the work of the activity using your code
                    - Returning the results using the SendTaskSuccess, SendTaskFailure, and SendTaskHeartbeat API actions.
                    - An AWS Lambda function
                - Activities can interact with other AWS services by passing parameters to the API actions of other services (https://docs.aws.amazon.com/step-functions/latest/dg/concepts-service-integrations.html).
    - Choice state ("Type": "Choice") adds branching logic to a state machine.
    - Wait state ("Type": "Wait") delays the state machine from continuing for a specified time.
    - Succeed state ("Type": "Succeed") stops an execution successfully. 
    - Fail state ("Type": "Fail") stops the execution of the state machine and marks it as a failure.
    - Parallel state ("Type": "Parallel") can be used to create parallel branches of execution in your state machine.
    - Map state ("Type": "Map") can be used to run a set of steps for each element of an input array. 
- Transitions
    - When an execution of a state machine is launched, the system begins with the state referenced in the top-level StartAt field. This field (a string) must exactly match, including case, the name of one of the states.
    - After executing a state, AWS Step Functions uses the value of the Next field to determine the next state to advance to.
    - Next fields also specify state names as strings, and must match the name of a state specified in the state machine description exactly (case sensitive).
- State Machine Data
    - State machine data takes the following forms:
        - The initial input into a state machine
        - Data passed between states
        - The output from a state machine
- The first example is based on a Linux Academy Lab:
    "Our company records its meetings and wants to build an automated pipeline to process meeting audio files. They use Amazon Transcribe, and want to trigger an action after the transcription is complete. But Amazon Transcribe is asynchronous, so we need to find a way to monitor the transcription job, so we can trigger a future action. We use step functions to solve it."
