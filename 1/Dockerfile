FROM julia:1.5-buster

WORKDIR /mnt/
COPY input.txt input.txt
COPY solve.jl solve.jl

ENTRYPOINT ["julia", "solve.jl"]
