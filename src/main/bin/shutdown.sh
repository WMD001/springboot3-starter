#!/bin/bash
kill -15 `ps -ef | grep search-front.jar | grep java | awk '{print $2}'`
