#!/usr/bin/env bash

sops updatekeys -y *.yaml
sops updatekeys -y *.sops
sops updatekeys -y *.pem

