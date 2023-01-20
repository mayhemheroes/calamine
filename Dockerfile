FROM rust as builder
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz

ADD . /calamine
WORKDIR /calamine/fuzz

RUN cargo fuzz build fuzz_all

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /calamine/fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_all /
