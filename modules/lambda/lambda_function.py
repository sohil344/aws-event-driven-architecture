import json
import boto3
import logging
import os

def setup_logger():
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    if not logger.handlers:
        handler = logging.StreamHandler()
        formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    return logger

logger = setup_logger()

def lambda_handler(event, context):
    logger.info("Lambda triggered by SQS event")
    
    # Initialize Step Functions client
    step_functions_client = boto3.client('stepfunctions')
    
    # Retrieve State Machine ARN from environment variable
    STATE_MACHINE_ARN = os.environ.get('STATE_MACHINE_ARN', 
        'arn:aws:states:us-east-1:664418997729:stateMachine:event-processing-workflow')
    
    for record in event['Records']:
        try:
            # Log the raw body before parsing
            logger.info(f"Raw record body: {record['body']}")

            if not record['body']:  
                logger.error("SQS message body is empty!")
                return {"statusCode": 400, "body": "SQS message body is empty"}

            # Parse the SQS message (SNS wrapper)
            sns_message = json.loads(record['body'])
            logger.info(f"Parsed SQS Body: {sns_message}")

            # Extract actual message
            if "Message" in sns_message:
                actual_message = sns_message["Message"]

                # Try parsing Message as JSON if possible
                try:
                    actual_message = json.loads(actual_message)  
                except json.JSONDecodeError:
                    # If it's not JSON, wrap it in a dictionary
                    actual_message = {"message": actual_message}

                logger.info(f"Extracted Message Body: {actual_message}")
            else:
                actual_message = sns_message  # Fallback if Message key is missing

            # Extract attributes and ensure it's a dictionary
            attributes = sns_message.get("MessageAttributes", {})
            if not isinstance(attributes, dict):
                attributes = {}

            logger.info(f"Message Attributes: {attributes}")

            print("Received Message:")
            print(json.dumps(actual_message, indent=4))

            print("Message Attributes:")
            print(json.dumps(attributes, indent=4))

            # Prepare input payload for Step Function
            # Ensure it's a dictionary with expected structure
            step_function_input = {
                "message": actual_message,
                "attributes": {
                    key: attr.get('Value', '') for key, attr in attributes.items()
                }
            }

            # Invoke Step Function
            try:
                # Start Step Function execution
                step_function_response = step_functions_client.start_execution(
                    stateMachineArn=STATE_MACHINE_ARN,
                    input=json.dumps(step_function_input)
                )
                
                logger.info(f"Step Function Execution Started: {step_function_response['executionArn']}")
            
            except Exception as step_func_error:
                logger.error(f"Error invoking Step Function: {step_func_error}")

        except json.JSONDecodeError as e:
            logger.error(f"JSON Decode Error: {e}")
            return {"statusCode": 400, "body": "Invalid JSON format"}

    return {"statusCode": 200, "body": "Processed Successfully"}