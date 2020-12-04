FROM julia:1.5-buster

WORKDIR /mnt/
COPY input.txt input.txt
COPY test_input.txt test_input.txt
COPY solve.jl solve.jl
COPY valid.txt valid.txt

ENTRYPOINT ["julia", "solve.jl"]
