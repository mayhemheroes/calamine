FROM rust:latest AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN rustup toolchain install nightly && \
    rustup default nightly && \
    cargo install cargo-fuzz

WORKDIR /calamine
COPY . .

RUN cargo fuzz build fuzz_all --release

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /calamine/fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_all /fuzz_all

CMD ["/fuzz_all"]
