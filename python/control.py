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


def freeze(thing):
    """
    Returns a hashable version of the thing passed.  Uses to create a memoization map.
    :param thing:
    :return:
    """
    if isinstance(thing, dict):
        return tuple([(freeze(k), freeze(v)) for k, v in sorted(thing.items())])
    if isinstance(thing, (float, int, str)):
        return thing
    if isinstance(thing, (tuple, list)):
        return tuple(map(freeze, thing))
    try:
        hash(thing)
    except TypeError:
        raise Exception("could not freeze:%r" % thing)
    return thing


def memoize(func, _cache=dict()):
    """
    See https://en.wikipedia.org/wiki/Memoization
    :param func: Function to memoize.
    :param _cache: memoization cache to use (works the same as a static local in C/C++).
    :return:
    """
    def faster(*a, **b):
        key = repr(freeze((func.__module__, func.__name__, a, b)))
        if key not in _cache:
            _cache[key] = func(*a, **b)
        return _cache[key]

    return faster


@memoize
def ssm():
    return boto3.client('ssm')


def list_parameters(prefix: str="/"):
    parameters = list()
    next_token = None
    while True:
        args = {"Path": prefix, "Recursive": True}
        if next_token:
            args["NextToken"] = next_token
        blob = ssm().get_parameters_by_path(**args)
        parameters += blob["Parameters"]
        next_token = blob.get("NextToken")
        if not next_token:
            break
    return [p["Name"] for p in parameters]


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
