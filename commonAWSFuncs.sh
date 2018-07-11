#!/bin/bash

# =====================================================
#    Convenience method for printing out a command
#             prompting user, then running
# =====================================================
runcmd() {
  echo ""
  local cmd=$1
  local skipprompt=$2

  if [ ! -z $skipprompt ]; then
      echo "Running: $cmd"
      eval $cmd
      return
  fi

  echo "Running: $cmd ... continue? y/n"
  read gonext
  if [ $gonext == "y" ]; then
    eval $cmd
  else
    echo "Skipping command"
  fi
}
