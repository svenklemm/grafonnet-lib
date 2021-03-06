#!/bin/sh

x=0

for i in `find . -name '*.jsonnet' -or -name '*.libsonnet'`
do
    t="Formating $i..."
    if [[ $1 == "update" ]]; then
        jsonnet fmt -i -n 4 $i
    fi
    if jsonnet fmt --test -n 4 $i;
    then
        echo $t OK
    else
        echo $t NOK
        x=1
    fi
done

for i in tests/*/*.jsonnet examples/*.jsonnet
do
    json=$(dirname $i)/$( basename $i .jsonnet )_test_output.json
    json_e=$(dirname $i)/$( basename $i .jsonnet )_compiled.json
    t="Compiling $i..."
    if jsonnet  -J . $i > $json
    then
        echo $t OK
    else
        echo $t NOK
        x=1
        continue
    fi

    if [[ $1 == "update" ]]; then cp $json $json_e; fi

    t="Checking $i..."
    if diff -urt $json $json_e
    then
        echo $t OK
    else
        echo $t NOK
        x=1
    fi
done
exit $x
