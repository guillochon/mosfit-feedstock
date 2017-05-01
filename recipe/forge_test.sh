#! /bin/bash
# TODO: adapt Mosfit's test.sh to properly work around mpich's bug.

set -e -x

function my_mpirun() {
    # Work around bug in mpich mpirun that leaves stdin/stdout
    # with the O_NONBLOCK flag set, which causes problems in various
    # contexts -- but not always, since bash sometimes clears the
    # flag after the program is run.
    mpirun "$@" </dev/null 2>&1 |cat
}

my_mpirun -np 2 python -m mosfit -e SN2009do --test -i 1 -f 1 -p 0 -F covariance

python -m mosfit -e SN2009do.json --test -i 1 --no-fracking -m magnetar \
       -T 2 -F covariance

python -m mosfit -e mosfit/tests/LSQ12dlf.json --test -i 3 --no-fracking \
       -m csm -F n 6.0 -W 120 -M 0.2 --offline

python -m mosfit -e SN2008ar --test -i 1 --no-fracking -m ia -F covariance

python -m mosfit -e mosfit/tests/LSQ12dlf.json --test -i 2 --no-fracking \
       -m rprocess --variance-for-each band --offline

python -m mosfit -e SN2007bg --test -i 1 --no-fracking -m ic

python -m mosfit -e 09do --test -i 1 --no-fracking -m slsn -S 20 -E 10.0 100.0 \
       -g -c --no-copy-at-launch -x radiusphot

python -m mosfit -e mosfit/tests/SN2006le.json --test -i 5 --no-fracking \
       -m csmni --extra-bands u g --extra-instruments LSST -L 55540 55560 \
       --exclude-bands B -s test --quiet -u --offline

python -m mosfit --test -i 0

python -m mosfit -i 0 -m default -P parameters_test.json

python test.py
