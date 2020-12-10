FROM julia:1.5-buster

WORKDIR /mnt/
COPY input.txt input.txt
COPY test_input.txt test_input.txt
COPY test_input_2.txt test_input_2.txt
COPY solve.jl solve.jl

ENTRYPOINT ["julia", "solve.jl"]
