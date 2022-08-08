#!/bin/sh

EDITOR_CMD="geany"

nohup "${EDITOR_CMD}" "${@}" >/dev/null 2>/dev/null &
