#!/bin/bash

eval $(opam env)

for tape in $(find . -name "demo.tape"); do
  pushd $(dirname $tape);
    vhs demo.tape;
  popd;
done
