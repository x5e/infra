#!/usr/bin/env python3
import boto3
import json
import sys
import os
client = boto3.client('ecs')
verbose = os.environ.get("VERBOSE", False)


def list_clusters():
    out = client.list_clusters()
    if verbose:
        print(json.dumps(out), file=sys.stderr)
    assert "nextToken" not in out  # @TODO
    return out["clusterArns"]


def list_container_instances(cluster):
    args = {
        "cluster": cluster,
    }
    out = client.list_container_instances(**args)
    if verbose:
        print(json.dumps(out), file=sys.stderr)
    assert "nextToken" not in out  # @TODO
    return out["containerInstanceArns"]


def list_services(cluster):
    args = {
        "cluster": cluster,
    }
    out = client.list_services(**args)
    if verbose:
        print(json.dumps(out), file=sys.stderr)
    assert "nextToken" not in out  # @TODO
    return out["serviceArns"]


def redeploy(cluster, service):
    args = {
        "cluster": cluster,
        "service": service,
        "forceNewDeployment": True,
    }
    out = client.update_service(**args)
    if verbose:
        print(json.dumps(out, default=str), file=sys.stderr)




if __name__ == "__main__":
    ordered_args = sys.argv[1:]
    if ordered_args and ordered_args[0] in globals():
        result = globals()[ordered_args[0]](*ordered_args[1:])
        if isinstance(result, str):
            print(result)
        elif isinstance(result, list):
            for _ in result:
                print(_)
        elif result is None:
            pass
        else:
            print(repr(result))
