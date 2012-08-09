#!/bin/bash

killall coffee
killall compass
killall hamlpy-watcher

coffee -w -c static &
compass watch static &
hamlpy-watcher ./ &
guard

