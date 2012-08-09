#!/bin/bash

hamlpy dev.haml index.html
compass compile static -e production --output-style compressed --force --no-line-comments

