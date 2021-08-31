#!/bin/bash
make clean deps lint package
make publish "forge_token=${PUPPETFORGE_TOKEN}"