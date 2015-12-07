#!/bin/bash

sudo yum update -y
sudo usermod -a -G wheel $USER && newgrp wheel
