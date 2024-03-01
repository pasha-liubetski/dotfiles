#!/bin/sh

EDITOR_CMD="notepadqq"

nohup "${EDITOR_CMD}" "${@}" >/dev/null 2>/dev/null &
