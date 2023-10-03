#!/bin/bash
rm generated.tf; terraform plan -generate-config-out=generated.tf