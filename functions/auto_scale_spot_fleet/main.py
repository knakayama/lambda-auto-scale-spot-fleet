import os
import json
import boto3
import pprint
pp = pprint.PrettyPrinter()


class SpotFleet(object):
    def __init__(self, ec2_client, sns_client, alarm_name):
        self.ec2_client = ec2_client
        self.sns_client = sns_client
        self.alarm_name = alarm_name
        self.spot_fleet_request_id = os.environ['SpotFleetRequestId']
        self.topic_arn = os.environ['TopicArn']

    def describe_spot_fleet_target_capacity(self):
        resp = self.ec2_client.describe_spot_fleet_requests(
                DryRun=False,
                SpotFleetRequestIds=[self.spot_fleet_request_id]
                )
        return resp['SpotFleetRequestConfigs'][0]['SpotFleetRequestConfig']['TargetCapacity']

    def modify_spot_fleet_target_capacity(self, target_capacity):
        self.ec2_client.modify_spot_fleet_request(
                SpotFleetRequestId=self.spot_fleet_request_id,
                TargetCapacity=target_capacity
                )

    def publish2topic(self, msg):
        req = {}
        req.update({
            'TopicArn': self.topic_arn,
            'Message': msg,
            'Subject': '[ALART] auto scale spot fleet'
            })
        return self.sns_client.publish(**req)


def handle(event, context):
    spot_fleet = SpotFleet(
            boto3.client('ec2'),
            boto3.client('sns'),
            json.loads(event['Records'][0]['Sns']['Message'])['AlarmName']
            )
    try:
        current_target_capacity = spot_fleet.describe_spot_fleet_target_capacity()
    except Exception as e:
        pp.pprint(e)
        spot_fleet.publish2topic(e)

    if spot_fleet.alarm_name == 'scale_out':
        target_capacity = current_target_capacity + 1
        if target_capacity >= 5:
            return
    else:
        target_capacity = current_target_capacity - 1
        if target_capacity <= 2:
            return

    try:
        spot_fleet.modify_spot_fleet_target_capacity(target_capacity)
    except Exception as e:
        pp.pprint(e)
        spot_fleet.publish2topic(e)

    spot_fleet.publish2topic(
            'Modify target capacity {} to {}'.format(
                current_target_capacity,
                target_capacity
                )
            )
