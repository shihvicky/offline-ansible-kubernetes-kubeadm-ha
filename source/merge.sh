#!/bin/bash

cat crio.tar.part* > crio.tar
cat helm.part* > helm

rm -rf crio.tar.part* helm.part*
